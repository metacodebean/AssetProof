
pragma solidity  0.8.1;

contract StateConst{
    //Some constants representing state
    //Sync state constant
    uint8 constant ASSETS_SNAPSHOT_IS_SYNCING = 1;
    
    uint8 constant ASSETS_SNAPSHOT_IS_NOT_SYNCING = 0;
    
    //User withdraw order state constant
    uint8 constant USER_WITHDRAW_ORDER_PENGING = 1;
    
    uint8 constant USER_WITHDRAW_ORDER_SUCCEED = 2;
    
    uint8 constant USER_WITHDRAW_ORDER_CANCELED = 3;
    
    //User withdraw snapshot state constant
    uint8 constant USER_WITHDRAW_SNAPSHOT_NOTHING = 0;
    
    uint8 constant USER_WITHDRAW_SNAPSHOT_PENDING = 1;
    
    uint8 constant USER_WITHDRAW_SNAPSHOT_SUCCEED = 2;
    
    //proposal state constant
    uint8 constant PROPOSAL_STATE_PENGING = 0;
    
    uint8 constant PROPOSAL_STATE_PASSED = 1;
    
    uint8 constant PROPOSAL_STATE_EXPIRED = 2;
    
    uint8 constant PROPOSAL_STATE_CANCELED = 3;
    
    //vote state constant
    uint8 constant VOTE_STATE_VOTED = 1;
    
    uint8 constant VOTE_STATE_NOT_VOTED = 0;

}

//Data structure used
contract DataStructure{
    
    //Administrators setup info
    struct AdminSetup{
         //Initially set up 5 administrator accounts and cannot be modified
         address[5] admins;
        
         //Address where you can initiate the withdrawal of the reserve
         address reservesWithdrawAddrSender;
         
         //Receiving address of reserve withdrawal
         address reservesWithdrawAddrReceiver;
    
         //Account address used to sync user asset snapshot.
         address assetSnapshotSyncAddress;
    
         //How many blocks are there between when the user initiates the withdrawal and when the withdrawal is successful
         uint256 blockNumsFromWithdrawInitToSucc;  //5760 blocks every day
    
         //Proposal expired blocks
         uint256 proposalExpiredBlocks;
        
    }
    
    //adminstrators setup info instance     
    AdminSetup adminSetupInfo;
    
    //User asset snapshot structure  update userSnapshot
    struct Snapshot {
        address[] users;
        uint256[] balances;
        mapping(address => uint8) withdrawFlags;
    }
    
    //Snapshot mapping version => snapshot struct
    mapping(uint64 => Snapshot) userSnapShots;
    
    //Snapshot info struct
    struct SnapshotState{
        //Current snapshot version
        uint64 currentSnapshotVersion;
        
        //Temporary snapshot version
        uint64 tempCurrentSnapshotVersion;

        //Totals of current snapshot assets
        uint256  snapshotTotalAssets;
    
        //Totals of temporary snapshot assets
        uint256 tempSnapshotTotalAssets;
    
        //Snapshot sync counter: the initial state is 0, the sync starts to accumulate 1,and the when replaced snapshot reset to 0
        uint32 syncCounter;
        
        //Snapshot sync state flag: the initial state is 0, when sync start set to 1, replaced completed reset to 0
        uint8 syncState;  //0 no syncing, 1 syncing 
        
    }
    
    //Snapshot state struct instance
    SnapshotState snapshotState;
    
    
    //The history of each snapshot includes quantity and total assets
    struct EveryBatchSnapshotHistory{
        uint32 usersNum;
        uint256 totalsAsset;
        uint256 snapshotDatetime;
    }
    
    //History of snapshot total assets
    mapping(uint64 => EveryBatchSnapshotHistory) snapshotHistories;
    
    
    //User Withdrawal order structure
    struct WithdrawOrder {
        uint64 orderId;
        address withdrawAddress;
        uint256 orderAmount;
        uint256 orderBlockHight; //Block height when the order occurs
        uint8 orderState;  //1 Pending，2 Released, 3 User canceled.
        uint64 orderVersion; // order version follow the current snapshot.
        uint256 orderDatetime;
     }
     
     //User withdrawal orders mapping
     mapping(uint64 => WithdrawOrder)  withdrawOrders;
     
     //last withdraw order id.
     uint64 lastOrderId;
     
     //Withdrawal order corresponding to the address
     mapping(address => uint64[])  addressOrdersIds;
     
     //Proposal structure
     struct ProposalInfo{
         uint64 plId;  //start from 1
         address sponsor;
         address withdrawAddrSender;
         address withdrawAddrReceiver;
         address snapshotSyncAddress;
         uint256 bokNumsFromWithdrawInitToSucc; 
         uint256 proposalExpiredBlocks;
         uint8 plState;  //0 pending  1 passed  2 expired  3 canceled
         uint256 plBlockHight;
         uint256 plDatetime;  //createDateTime
         address[] supporters;
     }
     
     //The current proposal number of an address
     mapping(address => uint64) addressCurrentProposalId;
     
     //Proposal mapping
     mapping(address => mapping(uint64 => ProposalInfo)) proposals;
     
     //Vote Proposal mapping  voter => sponsor => plid => state(0/1)
     mapping(address => mapping(address => mapping(uint64 => uint8))) voteProposalState;
     
}