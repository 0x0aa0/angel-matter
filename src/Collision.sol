// SPDX-License-Identifier: UNLICENSE
pragma solidity 0.8.20;

import {Data} from "./Data.sol";
import {Base64} from "../lib/solady/src/utils/Base64.sol";
import {LibString} from "../lib/solady/src/utils/LibString.sol";
import {IFileStore} from "../lib/ethfs/packages/contracts/src/IFileStore.sol";

contract Collision {
    using LibString for uint256;

    IFileStore fileStore;
    string desc =
        '"description":"In a far away parallel universe an advanced civilization built a computer around a star and escaped into a simulated reality. After some immeasurable amount of time these facts were forgotten and after another immeasurable amount of time that star began to die. Even so, life Inside this simulation progressed, and on one planet some of that life progressed enough to form a government. You are the new member of a mysterious project under a secret agency of this government researching the elementary particles that make up your universe.",';

    constructor(address _fileStore) {
        fileStore = IFileStore(_fileStore);
    }

    function _parameters(uint256 _id) internal pure returns (string memory) {
        return
            string.concat(
                '<script src="data:text/javascript;base64,',
                Base64.encode(
                    abi.encodePacked(
                        string.concat(
                            "let seed = ",
                            _id.toString(),
                            _id == 0 ? "; let mode = 1;" : "; let mode = 0;"
                        )
                    )
                )
            );
    }

    function _scripts(uint256 _id) internal view returns (string memory) {
        return
            string.concat(
                '<script type="text/javascript+gzip" src="data:text/javascript;base64,',
                fileStore.getFile("p5-v1.5.0.min.js.gz").read(),
                '"></script>',
                '<script src="data:text/javascript;base64,',
                fileStore.getFile("gunzipScripts-0.0.1.js").read(),
                '"></script>',
                _parameters(_id),
                '"></script><script src="data:text/javascript;base64,CmZ1bmN0aW9uIHNldHVwKCkgewogIGNyZWF0ZUNhbnZhcyg1MDAsIDUwMCk7CiAgYmxlbmRNb2RlKEhBUkRfTElHSFQpOwogIG5vU3Ryb2tlKCk7CiAgcmFuZG9tU2VlZChzZWVkKTsKICBpZihtb2RlID09IDApewogICAgbm9Mb29wKCk7CiAgfQp9CgpmdW5jdGlvbiBkcmF3KCkgewogIGJhY2tncm91bmQoMCk7CiAgaWYobW9kZSA9PSAwKXsKICAgIHN0YXIoMTI1LDEyNSwyNTApOwogICAgc3RhcigzNzUsMzc1LDI1MCk7CiAgICBzdGFyKDM3NSwxMjUsMjUwKTsKICAgIHN0YXIoMTI1LDM3NSwyNTApOyAKICAgIGZpbHRlcihJTlZFUlQpCiAgfSBlbHNlIHsKICAgIGJhY2tncm91bmQoMCk7CiAgZm9yKHZhciBpID0gMDsgaSA8IDU7IGkrKyl7CiAgICB0cmlhbmdsZShyYW5kb20oNDAwLDUwMCksIHJhbmRvbSg0MDAsNTAwKSwgcmFuZG9tKDIwMCwzMDApLCByYW5kb20oMjAwLDMwMCksIHJhbmRvbSgyMDAsMzAwKSwgcmFuZG9tKDIwMCwzMDApKTsKICAgIHRyaWFuZ2xlKHJhbmRvbSgxMDApLCByYW5kb20oMTAwKSwgcmFuZG9tKDIwMCwzMDApLCAgIHJhbmRvbSgyMDAsMzAwKSwgcmFuZG9tKDIwMCwzMDApLCByYW5kb20oMjAwLDMwMCkpOwogICAgdHJpYW5nbGUocmFuZG9tKDQwMCw1MDApLCByYW5kb20oMTAwKSwgcmFuZG9tKDIwMCwzMDApLCByYW5kb20oMjAwLDMwMCksIHJhbmRvbSgyMDAsMzAwKSwgcmFuZG9tKDIwMCwzMDApKTsKICAgIHRyaWFuZ2xlKHJhbmRvbSgxMDApLCByYW5kb20oNDAwLDUwMCksIHJhbmRvbSgyMDAsMzAwKSwgICByYW5kb20oMjAwLDMwMCksIHJhbmRvbSgyMDAsMzAwKSwgcmFuZG9tKDIwMCwzMDApKTsKICAgIHRyaWFuZ2xlKHJhbmRvbSgyMDAsMzAwKSwgcmFuZG9tKDQwMCw1MDApLCByYW5kb20oMjAwLDMwMCksIHJhbmRvbSgyMDAsMzAwKSwgcmFuZG9tKDIwMCwzMDApLCByYW5kb20oMjAwLDMwMCkpOwogICAgdHJpYW5nbGUocmFuZG9tKDIwMCwzMDApLCByYW5kb20oMTAwKSwgcmFuZG9tKDIwMCwzMDApLCAgIHJhbmRvbSgyMDAsMzAwKSwgcmFuZG9tKDIwMCwzMDApLCByYW5kb20oMjAwLDMwMCkpOwogICAgdHJpYW5nbGUocmFuZG9tKDQwMCw1MDApLCByYW5kb20oMjAwLDMwMCksIHJhbmRvbSgyMDAsMzAwKSwgcmFuZG9tKDIwMCwzMDApLCByYW5kb20oMjAwLDMwMCksIHJhbmRvbSgyMDAsMzAwKSk7CiAgICB0cmlhbmdsZShyYW5kb20oMTAwKSwgcmFuZG9tKDIwMCwzMDApLCByYW5kb20oMjAwLDMwMCksICAgcmFuZG9tKDIwMCwzMDApLCByYW5kb20oMjAwLDMwMCksIHJhbmRvbSgyMDAsMzAwKSk7CiAgICBmaWx0ZXIoSU5WRVJUKQogIH0KICBmaWx0ZXIoSU5WRVJUKQogIH0KfQoKZnVuY3Rpb24gc3Rhcih4LCB5LCBzKXsKICBmb3IodmFyIGkgPSAwOyBpIDwgNTsgaSsrKXsKICAgIHIgPSAoKGkrMSkgKiA1MCkgLSByYW5kb20oMjU1IC0gKGkqNTApKQogICAgZyA9ICgoaSsxKSAqIDUwKSAtIHJhbmRvbSgyNTUgLSAoaSo1MCkpCiAgICBiID0gKChpKzEpICogNTApIC0gcmFuZG9tKDI1NSAtIChpKjUwKSkKICAgIGZpbGwocixnLGIpOwoKICAgIHhfeiA9IHggLSAocy8yKQogICAgeF9vID0geF96ICsgKHMvNCkKICAgIHhfdCA9IHggLSAocy80KQogICAgeF90aCA9IHggKyAocy80KQogICAgeF9maSA9IHggKyAocy8yKQogICAgeF9mbyA9IHhfZmkgLSAocy80KQoKICAgIHlfeiA9IHkgLSAocy8yKQogICAgeV9vID0geV96ICsgKHMvNCkKICAgIHlfdCA9IHkgLSAocy80KQogICAgeV90aCA9IHkgKyAocy80KQogICAgeV9maSA9IHkgKyAocy8yKQogICAgeV9mbyA9IHlfZmkgLSAocy80KQoKICAgIHRyaWFuZ2xlKHJhbmRvbSh4X2ZvLCB4X2ZpKSwgcmFuZG9tKHlfZm8sIHlfZmkpLCByYW5kb20oeF90LHhfdGgpLCByYW5kb20oeV90LHlfdGgpLCByYW5kb20oeF90LHhfdGgpLCByYW5kb20oeV90LHlfdGgpKTsKICAgICAgdHJpYW5nbGUocmFuZG9tKHhfeiwgeF9vKSwgcmFuZG9tKHlfeiwgeV9vKSwgcmFuZG9tKHhfdCx4X3RoKSwgcmFuZG9tKHlfdCx5X3RoKSwgcmFuZG9tKHhfdCx4X3RoKSwgcmFuZG9tKHlfdCx5X3RoKSk7CiAgICAgIHRyaWFuZ2xlKHJhbmRvbSh4X2ZvLCB4X2ZpKSwgcmFuZG9tKHlfeiwgeV9vKSwgcmFuZG9tKHhfdCx4X3RoKSwgcmFuZG9tKHlfdCx5X3RoKSwgcmFuZG9tKHhfdCx4X3RoKSwgcmFuZG9tKHlfdCx5X3RoKSk7CiAgICAgIHRyaWFuZ2xlKHJhbmRvbSh4X3osIHhfbyksIHJhbmRvbSh5X2ZvLHlfZmkpLCByYW5kb20oeF90LHhfdGgpLCByYW5kb20oeV90LHlfdGgpLCByYW5kb20oeF90LHhfdGgpLCByYW5kb20oeV90LHlfdGgpKTsKICAgIAogICAgZmlsdGVyKElOVkVSVCkKICB9Cn0="></script>'
            );
    }

    function _page(uint256 _id) internal view returns (string memory) {
        return
            string.concat(
                '"animation_url":"data:text/html;base64,',
                Base64.encode(
                    abi.encodePacked(
                        string.concat(
                            '<!DOCTYPE html><html style="height: 100%;"><head>',
                            _scripts(_id),
                            '</head><body style="margin: 0;display: flex;justify-content: center;align-items: center;height: 100%;"></body></html>'
                        )
                    )
                ),
                '"}'
            );
    }

    function uri(uint256 _id) external view returns (string memory) {
        return
            string.concat(
                "data:application/json;base64,",
                Base64.encode(
                    abi.encodePacked(
                        string.concat(
                            '{"name":"< ',
                            _id > 0 ? _id.toString() : "...",
                            ' >",',
                            desc,
                            '"image":"',
                            Data._image(_id),
                            '",',
                            _page(_id)
                        )
                    )
                )
            );
    }
}
