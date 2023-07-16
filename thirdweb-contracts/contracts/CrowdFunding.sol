// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract CrowdFunding {
    struct Campaign{
        address owner;
        string title;
        string description;
        uint256 target;
        uint256 deadline;
        uint256 amountCollected;
        string image;
        address[] donators;
        uint256[] donations;
    }


    mapping(uint256 => Campaign) public campaigns;  


    uint256 public numberOfCampaigns = 0;

    //returns (uint256) species that it will return id of campaign for following 
    function createCampaign(address _owner, string memory _title, string memory _description, uint256 _target, uint _deadline, string memory _image) public returns (uint256) {
        Campaign storage campaign = campaigns[numberOfCampaigns];

        //if any condition
        require(campaign.deadline < block.timestamp, "The deadline should be in future");
        campaign.owner = _owner;
        campaign.title = _title;
        campaign.description= _description;
        campaign.target = _target;
        campaign.deadline = _deadline;
        campaign.amountCollected = 0;
        campaign.image = _image;

        numberOfCampaigns++;
 
        return numberOfCampaigns - 1;  //index of new created campaign

    }


    //payable species that some cryptocurrency will be used
    function donateToCampaign(uint256 _id) public payable  {
        uint256 amount = msg.value;
        Campaign storage campaign = campaigns[_id];

        campaign.donators.push(msg.sender);
        campaign.donations.push(amount);

        (bool sent,) = payable(campaign.owner).call{value: amount}("");

        if(sent){
            campaign.amountCollected = campaign.amountCollected + amount;
        }
    }


    //address - donators, uint256- donations
    function getDonators(uint256 _id) view public returns(address[] memory, uint256[] memory) {
        return (campaigns[_id].donators, campaigns[_id].donations);
    }

    function getCampaigns() public view returns (Campaign[] memory) {
        Campaign[] memory allCampaigns = new Campaign[](numberOfCampaigns); //creating a new array with memory equal to total campaigns
        for(uint i=0; i<numberOfCampaigns; i++){
            Campaign storage item = campaigns[i];
            allCampaigns[i] = item; //storing campaigns in new array
        }

        return allCampaigns;
    }
}