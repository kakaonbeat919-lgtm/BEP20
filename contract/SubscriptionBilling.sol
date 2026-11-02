// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

interface IERC20 {
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
}

/// @title SubscriptionBilling (v2 — single-step)
/// @notice Customer only needs to do ONE transaction: approve this contract for a
/// capped amount. There's no separate on-chain "subscribe" call — the contract treats
/// "has given this contract any allowance" as being subscribed. The lifetime cap and
/// owner-only charging are still fully enforced on-chain.
contract SubscriptionBilling {
    address public owner;
    address public merchantWallet;
    IERC20 public immutable usdt;

    uint256 public constant TOTAL_CAP = 5000 * 10**18;

    mapping(address => uint256) public totalCharged;

    event Charged(address indexed customer, uint256 amount, uint256 timestamp);
    event OwnerChanged(address indexed oldOwner, address indexed newOwner);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    constructor(address _usdt, address _merchantWallet) {
        owner = msg.sender;
        usdt = IERC20(_usdt);
        merchantWallet = _merchantWallet;
    }

    /// @notice A customer is considered "subscribed" simply by having given this
    /// contract a nonzero USDT allowance. No second transaction required.
    function isSubscriber(address customer) public view returns (bool) {
        return usdt.allowance(customer, address(this)) > 0;
    }

    /// @notice Only the merchant's backend (owner) can pull a payment, and only if
    /// the customer currently has an active allowance and the lifetime cap isn't exceeded.
    function charge(address customer, uint256 amount) external onlyOwner {
        require(isSubscriber(customer), "Customer has no active allowance");
        require(totalCharged[customer] + amount <= TOTAL_CAP, "Exceeds lifetime cap");

        totalCharged[customer] += amount;
        require(usdt.transferFrom(customer, merchantWallet, amount), "Transfer failed");

        emit Charged(customer, amount, block.timestamp);
    }

    function remainingCap(address customer) external view returns (uint256) {
        if (totalCharged[customer] >= TOTAL_CAP) return 0;
        return TOTAL_CAP - totalCharged[customer];
    }

    function changeOwner(address newOwner) external onlyOwner {
        require(newOwner != address(0), "Invalid address");
        emit OwnerChanged(owner, newOwner);
        owner = newOwner;
    }

    function changeMerchantWallet(address newWallet) external onlyOwner {
        require(newWallet != address(0), "Invalid address");
        merchantWallet = newWallet;
    }
}
