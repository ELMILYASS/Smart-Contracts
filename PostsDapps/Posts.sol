// SPDX-License-Identifier: MIT


pragma solidity ^0.8.0;

contract Ownable{
    address public owner ;
    constructor(){
        owner=msg.sender ;
    }
    modifier onlyOwner(){
        require(owner ==msg.sender ,"You are not the owner");
        _;
    }
}

interface IUserProfile {
    struct UserProfile {
        string displayName;
        string bio;
    }
    
    function getProfile (address _user) external view returns (UserProfile memory);
}
contract Posts is Ownable{

    uint16 public MAX_Post_LENGTH = 280;
    IUserProfile profileContract;
    modifier onlyRegistered(){
        IUserProfile.UserProfile memory userProfile = profileContract.getProfile(msg.sender);
        require(bytes(userProfile.displayName).length > 0, "USER NOT REGISTERED");
        _;
    }
    struct Post {
        uint256 id;
        address author;
        string content;
        uint256 likes;
    }
    mapping(address => Post[] ) private Posts;
   
    event PostCreated(uint256 id, address author, string content);
    event PostLiked(address liker, address PostAuthor, uint256 PostId, uint256 newLikeCount);
    event PostUnliked(address unliker, address PostAuthor, uint256 PostId, uint256 newLikeCount);
    constructor(address _profileContract) {
        profileContract = IUserProfile(_profileContract);
    }

    function changePostLength(uint16 newPostLength) public onlyOwner {
        MAX_Post_LENGTH = newPostLength;
    }

    function createPost(string memory content) public onlyRegistered{
        require(bytes(content).length <= MAX_Post_LENGTH, "Post is too long " );

        Post memory newPost = Post({
            id: Posts[msg.sender].length,
            author: msg.sender,
            content: content,
            likes: 0
        });

        Posts[msg.sender].push(newPost);
        emit PostCreated(newPost.id, newPost.author, newPost.content);

    }

    function likePost(address author, uint256 id) external onlyRegistered{  
        require(Posts[author][id].id == id, "Post DOES NOT EXIST");

        Posts[author][id].likes++;
         emit PostLiked(msg.sender, author, id, Posts[author][id].likes);
    }

    function unlikePost(address author, uint256 id) external onlyRegistered{
        require(Posts[author][id].id == id, "Post DOES NOT EXIST");
        require(Posts[author][id].likes > 0, "Post HAS NO LIKES");
        
        Posts[author][id].likes--;
        emit PostUnliked(msg.sender, author, id, Posts[author][id].likes );
    }

    function getPost( uint _i) public view returns (Post memory) {
        return Posts[msg.sender][_i];
    }

    function getAllPosts(address _owner) public view returns (Post[] memory ){
        return Posts[_owner];
    }

}

