import Principal "mo:base/Principal";
import Cycles "mo:base/ExperimentalCycles";
import Debug "mo:base/Debug";
import HashMap "mo:base/HashMap";
import List "mo:base/List";
import NFTActorClass "../NFT/nft";


actor OpenD {

    var mapOfNFTs = HashMap.HashMap<Principal,NFTActorClass.NFT>(1,Principal.equal,Principal.hash);
    var mapOfOwners = HashMap.HashMap<Principal,List.List<Principal>>(1,Principal.equal,Principal.hash);
    var mapOfListings = HashMap.HashMap

    public shared(msg) func mint(imgData: [Nat8], name : Text) : async Principal{
        let owner : Principal = msg.caller;

        Debug.print(debug_show(Cycles.balance()));
            Cycles.add(100_500_000_000);
        

        let newNFT = await NFTActorClass.NFT(name,owner,imgData);
        Debug.print(debug_show(Cycles.balance()));

        let newNFTPrincipal = await newNFT.getCanisterId();
        addToOwnershipMap(owner,newNFTPrincipal);

        mapOfNFTs.put(newNFTPrincipal,newNFT);

        return newNFTPrincipal;
    };


    private func addToOwnershipMap(owner: Principal, nftId: Principal){
        var ownedNFts : List.List<Principal> = switch(mapOfOwners.get(owner)){
            case null List.nil<Principal>();
            case (?result) result;
        };

        ownedNFts := List.push(nftId,ownedNFts);
        mapOfOwners.put(owner,ownedNFts);
    };


    public query func getOwnedNFTs(user: Principal) : async [Principal]{
        var userNFTs : List.List<Principal> = switch (mapOfOwners.get(user)){
         case null List.nil<Principal>();
         case (?result) result;
        };
         
        return List.toArray(userNFTs);
    };

    public shared(msg) func listItem(id: Principal, price: Nat){

    }
};
