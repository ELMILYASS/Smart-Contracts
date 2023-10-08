// SPDX-License-Identifier: MIT


pragma solidity ^0.8.0;

contract Posts {

    uint16 public MAX_Post_LENGTH = 280;

    struct Post {
        uint256 id;
        address author;
        string content;
        uint256 likes;
    }
    mapping(address => Post[] ) private Posts;
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "YOU ARE NOT THE OWNER!");
        _;
    }

    function changePostLength(uint16 newPostLength) public onlyOwner {
        MAX_Post_LENGTH = newPostLength;
    }

    function createPost(string memory _Post) public {
        require(bytes(_Post).length <= MAX_Post_LENGTH, "Post is too long " );

        Post memory newPost = Post({
            id: Posts[msg.sender].length,
            author: msg.sender,
            content: _Post,
            likes: 0
        });

        Posts[msg.sender].push(newPost);
    }

    function likePost(address author, uint256 id) external {  
        require(Posts[author][id].id == id, "Post DOES NOT EXIST");

        Posts[author][id].likes++;
    }

    function unlikePost(address author, uint256 id) external {
        require(Posts[author][id].id == id, "Post DOES NOT EXIST");
        require(Posts[author][id].likes > 0, "Post HAS NO LIKES");
        
        Posts[author][id].likes--;
    }

    function getPost( uint _i) public view returns (Post memory) {
        return Posts[msg.sender][_i];
    }

    function getAllPosts(address _owner) public view returns (Post[] memory ){
        return Posts[_owner];
    }

}