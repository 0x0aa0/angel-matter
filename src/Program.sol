// SPDX-License-Identifier: UNLICENSE
pragma solidity 0.8.20;

import {Particle} from "./Particle.sol";
import {Base64} from "../lib/solady/src/utils/Base64.sol";
import {LibString} from "../lib/solady/src/utils/LibString.sol";
import {IFileStore} from "../lib/ethfs/packages/contracts/src/IFileStore.sol";

struct Params {
    uint256 id;
    uint256 seed;
    uint256 pres;
    string ar;
    address wal;
    uint8 inv;
    uint8 lvl;
    uint8 asc;
}

contract Program {
    using LibString for uint256;
    using LibString for uint160;
    using LibString for uint8;

    IFileStore fileStore;
    string desc = '"description": "Placeholder",';

    constructor(address _fileStore) {
        fileStore = IFileStore(_fileStore);
    }

    function _parameters(
        Params memory _params
    ) internal view returns (string memory) {
        return
            string.concat(
                '<script src="data:text/javascript;base64,',
                Base64.encode(
                    abi.encodePacked(
                        string.concat(
                            "let seed = ",
                            (_params.seed % 9007199254740991).toString(),
                            "; let tim = ",
                            block.timestamp.toString(),
                            "; let ar = ",
                            _params.ar,
                            "; let wal = ",
                            (uint160(_params.wal) % 9007199254740991)
                                .toString(),
                            "; let inv = ",
                            _params.inv.toString(),
                            "; let lvl = ",
                            _params.lvl.toString(),
                            "; let asc = ",
                            _params.asc.toString(),
                            ";"
                        )
                    )
                )
            );
    }

    function _scripts(
        Params memory _params
    ) internal view returns (string memory) {
        return
            string.concat(
                '<script type="text/javascript+gzip" src="data:text/javascript;base64,',
                fileStore.getFile("p5-v1.5.0.min.js.gz").read(),
                '"></script>',
                '<script src="data:text/javascript;base64,',
                fileStore.getFile("gunzipScripts-0.0.1.js").read(),
                '"></script>',
                _parameters(_params),
                '"></script><script src="data:text/javascript;base64,CmZ1bmN0aW9uIHNldHVwKCkgewogIGNyZWF0ZUNhbnZhcyg1MDAsIDUwMCk7CiAgY3Vyc29yKENST1NTKTsKfQoKbGV0IGFydCA9IDA7CmZ1bmN0aW9uIGRyYXcoKSB7CiAgaWYoYXJ0ID09IDApewogICAgaG9tZSgpOwogIH0KICBpZihhcnQgPT0gMSl7CiAgICBldmkoKTsKICB9CiAgaWYoYXJ0ID09IDIpewogICAgc2EoKTsKICB9CiAgaWYoYXJ0ID09IDMpewogICAgcGVjKCk7CiAgfQogIGlmKGFydCA9PSA0KXsKICAgIHN0ZCgpOwogIH0KICBpZihhcnQgPT0gNSl7CiAgICBmaW4oKTsKICB9Cn0KCmZ1bmN0aW9uIG1vdXNlQ2xpY2tlZCgpIHsKICBpZihhcnQgPT0gMCl7CiAgICBpZihtb3VzZVkgPiAyMDAgJiYgbW91c2VZIDwgMjIwKXsKICAgICAgYXJ0ID0gMTsKICAgIH0KICAKICAgIGlmKG1vdXNlWSA+IDIyMCAmJiBtb3VzZVkgPCAyNDUpewogICAgICBhcnQgPSAyOwogICAgfQoKICAgIGlmKG1vdXNlWSA+IDI0NSAmJiBtb3VzZVkgPCAyNzApewogICAgICBhcnQgPSAzOwogICAgfQoKICAgIGlmKG1vdXNlWSA+IDI3MCAmJiBtb3VzZVkgPCAyOTUpewogICAgICBhcnQgPSA0OwogICAgfQogICAgCiAgICBpZihtb3VzZVkgPiAxMTAgJiYgbW91c2VZIDwgMTUwICYmIGFzYyA+IDApewogICAgICBhcnQgPSA1OwogICAgfQogIH0KICBpZihhcnQgPT0gMSB8fCBhcnQgPT0gNCl7CiAgICBmaWx0ZXIoSU5WRVJUKTsKICB9Cn0KCmZ1bmN0aW9uIGtleVByZXNzZWQoKSB7CiAgaWYgKGtleUNvZGUgPT09IDMyKSB7CiAgICBhcnQgPSAwOwogICAgYmxlbmRNb2RlKEJMRU5EKTsKICAgIGxvb3AoKTsKICB9Cn0KCmxldCBhbSA9ICdfX19fX19fX19fX19fX18gQU5HRUwgTUFUVEVSIF9fX19fX19fX19fX19fXyc7CmxldCBwbSA9ICdfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18nOwpsZXQgY2NjOwpsZXQgbzE7CmxldCBvMjsKbGV0IG8zOwpsZXQgbzQ7CmxldCBhMSA9ICc+Pj4gICBFeHRlcmlvciBXYXZlZmllbGQgSW50ZXJhY3Rpb24gICA8PDwnOwpsZXQgYTIgPSAnPj4+ICAgU3ViZGltZW5zaW9uYWwgQXJjaGl0ZWN0dXJlICAgPDw8JzsKbGV0IGEzID0gJz4+PiAgUGVudGFnb25hbCBFbGVtZW50IENvbGxhcHNlICA8PDwnOwpsZXQgYTQgPSAnPj4+ICBTdGF0aWMgVHJhbnNtaXNzaW9uIERlY2F5ICA8PDwnOwpsZXQgYjEgPSAnPj4+IEV4dGVyaW9yIFdhdmVmaWVsZCBJbnRlcmFjdGlvbiA8PDwnOwpsZXQgYjIgPSAnPj4+IFN1YmRpbWVuc2lvbmFsIEFyY2hpdGVjdHVyZSA8PDwnOwpsZXQgYjMgPSAnPj4+IFBlbnRhZ29uYWwgRWxlbWVudCBDb2xsYXBzZSA8PDwnOwpsZXQgYjQgPSAnPj4+IFN0YXRpYyBUcmFuc21pc3Npb24gRGVjYXkgPDw8JzsKZnVuY3Rpb24gaG9tZSgpewogIHRleHRTaXplKDE4KTsKICB0ZXh0Rm9udCgnbW9ub3NwYWNlJyk7CiAgdGV4dEFsaWduKENFTlRFUik7CiAgYmFja2dyb3VuZCgwKTsKICBmaWxsKDI1NSk7CiAgbm9TdHJva2UoKTsKICBvMSA9IGExOwogIG8yID0gYTI7CiAgbzMgPSBhMzsKICBvNCA9IGE0OwogIAogIGlmKG1vdXNlWSA+IDIwMCAmJiBtb3VzZVkgPCAyMjApewogICAgbzEgPSBiMTsKICAgIG8yID0gYTI7CiAgICBvMyA9IGEzOwogICAgbzQgPSBhNDsKICB9CiAgCiAgaWYobW91c2VZID4gMjIwICYmIG1vdXNlWSA8IDI0NSl7CiAgICBvMSA9IGExOwogICAgbzIgPSBiMjsKICAgIG8zID0gYTM7CiAgICBvNCA9IGE0OwogIH0KICAKICBpZihtb3VzZVkgPiAyNDUgJiYgbW91c2VZIDwgMjcwKXsKICAgIG8xID0gYTE7CiAgICBvMiA9IGEyOwogICAgbzMgPSBiMzsKICAgIG80ID0gYTQ7CiAgfQogIAogIGlmKG1vdXNlWSA+IDI3MCAmJiBtb3VzZVkgPCAyOTUpewogICAgbzEgPSBhMTsKICAgIG8yID0gYTI7CiAgICBvMyA9IGEzOwogICAgbzQgPSBiNDsKICB9CiAgCiAgdGV4dChhbSwgMjUwLCAxODApOwogIHRleHQobzEsIDI1MCwgMjE1KTsKICB0ZXh0KG8yLCAyNTAsIDI0MCk7CiAgdGV4dChvMywgMjUwLCAyNjUpOwogIHRleHQobzQsIDI1MCwgMjkwKTsKICB0ZXh0KHBtLCAyNTAsIDMxMCk7CiAgCiAgY2NjID0nL1x0XHRcXFxuXFxcdFx0Lyc7CiAgaWYobW91c2VZID4gMTEwICYmIG1vdXNlWSA8IDE1MCl7CiAgICBjY2M9Jy9cdFx0XHRcXFxuXFxcdFx0XHQvJzsKICB9CiAgaWYoYXNjID4gMCl7CiAgICB0ZXh0KGNjYywgMjUwLCAxMjApOwogICAgdGV4dCgnLi4uJywgMjUwLCAxMzApOwp0ZXh0KCcvL1x0XHRcdFx0XHRcdFxcXFxcbi8vXHRcdFx0XHRcdFx0XHRcXFxcXG4vL1x0XHRcdFx0XHRcdFx0XHRcXFxcXG4vLyBfX19fX19fX19fX19fX19fIFxcXFwnLCAyNTAsIDM0MCk7CiAgfQp9CgpmdW5jdGlvbiBldmkoKXsKICBub0xvb3AoKTsKICBiYWNrZ3JvdW5kKDIyNSk7CiAgbm9GaWxsKCk7CiAgYmxlbmRNb2RlKE1VTFRJUExZKTsKICAKICByYW5kb21TZWVkKHNlZWQpOwogIGxldCBjb2xzID0gW107CiAgZm9yKHZhciBpID0gMDsgaSA8IDMwOyBpKyspewogICAgY29scy5wdXNoKHJhbmRvbSgyNTUpKTsKICB9CiAgCiAgcmFuZG9tU2VlZCh3YWwpOwogIGZvcih2YXIgaSA9IDA7IGkgPCAxMDsgaSsrKXsKICAgIHN0cm9rZShjb2xzW2kqM10sY29sc1tpKjMrMV0sY29sc1tpKjMrMl0pOwogICAgYiA9IGZsb29yKHJhbmRvbSg0MDAsIDUwMCkpOwogICAgYyA9IGZsb29yKHJhbmRvbSgxMDAsIDIwMCkpOwogICAgZCA9IGZsb29yKHJhbmRvbSgzMDAsIDQwMCkpOwogICAgCiAgICBiZXppZXIoMCwgNTAwIC0gYiwgYywgYywgZCwgZCwgNTAwLCBiKTsKICAgIGJlemllcig1MDAgLSBiLCAwLCBjLCBjLCBkLCBkLCBiLCA1MDApOwogICAgYmV6aWVyKDAsIDUwMCAtIGIsIGQsIGQsIGMsIGMsIDUwMCwgYik7CiAgICBiZXppZXIoNTAwIC0gYiwgMCwgZCwgZCwgYywgYywgYiwgNTAwKTsKICAgIAogICAgYmV6aWVyKDAsIGIsIGQsIGQsIGMsIGMsIDUwMCwgNTAwIC0gYik7CiAgICBiZXppZXIoYiwgMCwgZCwgZCwgYywgYywgNTAwIC0gYiwgNTAwKTsKICAgIGJlemllcigwLCBiLCBjLCBjLCBkLCBkLCA1MDAsIDUwMCAtIGIpOwogICAgYmV6aWVyKGIsIDAsIGMsIGMsIGQsIGQsIDUwMCAtIGIsIDUwMCk7CiAgICAKICAgIGJlemllcigwLCA1MDAgLSBiLCBkLCBkLCBjLCBjLCA1MDAsIDUwMCAtIGIpOwogICAgYmV6aWVyKDUwMCAtIGIsIDAsIGQsIGQsIGMsIGMsIDUwMCAtIGIsIDUwMCk7CiAgICBiZXppZXIoMCwgNTAwIC0gYiwgYywgYywgZCwgZCwgNTAwLCA1MDAgLSBiKTsKICAgIGJlemllcig1MDAgLSBiLCAwLCBjLCBjLCBkLCBkLCA1MDAgLSBiLCA1MDApOwogIH0KICAKICBmaWxsKCIjRkZGNiIpOwogIG5vU3Ryb2tlKCk7CiAgcmVjdCgwLDAsNTAwLDUwMCk7CiAgCiAgcHVzaCgpOwogICAgZmlsbCgiI0ZGRiIpOwogICAgbm9TdHJva2UoKTsKICAgIGJsZW5kTW9kZShESUZGRVJFTkNFKTsKICAgIGNpcmNsZSgyNTAsMjUwLDI1MCk7CiAgcG9wKCk7CiAgCiAgaWYoaW52ID09IDEpewogICAgZmlsdGVyKElOVkVSVCk7CiAgfQp9CgoKZnVuY3Rpb24gc2EoKXsKICBub0xvb3AoKTsKICBjcmVhdGVDYW52YXMoNTAwLCA1MDApOwogIG5vU3Ryb2tlKCk7CiAgbm9pc2VTZWVkKHNlZWQpOwogIHJhbmRvbVNlZWQoc2VlZCk7CiAgCiAgbGV0IHQgPSAodGltIC8gODY0MDApICogMC4xCiAgZm9yICh2YXIgeCA9IDA7IHggPCA1MDA7IHggKz0gMikgewogICAgICBmb3IgKHZhciB5ID0gMDsgeSA8IDUwMDsgeSArPSAyKSB7CiAgICAgICAgdmFyIHIgPSAyNTUgKiBub2lzZSgwLjAxICogKHggLSAyNjApLCAwLjAxICogKHkgLSAyNjApLCB0KTsKICAgICAgICB2YXIgZyA9IDI1NSAqIG5vaXNlKDAuMDEgKiAoeCAtIDI1MCksIDAuMDEgKiAoeSAtIDI1MCksIHQpOwogICAgICAgIHZhciBiID0gMjU1ICogbm9pc2UoMC4wMSAqICh4IC0gMjQwKSwgMC4wMSAqICh5IC0gMjQwKSwgdCk7CiAgICAgICAgZmlsbChyLGcsYik7CiAgICAgICAgcmVjdCh4LCB5LCAyKTsKICAgICAgfQkJCiAgICB9CiAgCiAgZmlsbCgiI0ZGRjEiKTsKICBzdHJva2UoIiNGRkYiKTsKICBmb3IgKHZhciB4ID0gMDsgeCA8IDI1MDsgeCArPSAyNSkgewogICAgICBmb3IgKHZhciB5ID0gMDsgeSA8IDI1MDsgeSArPSAyNSkgewogICAgICAgIGlmKHJhbmRvbSgxKSA+IDAuNjY2KXsKICAgICAgICAgIGNpcmNsZSgwICsgeCwgMCArIHksIDEwMCk7CiAgICAgICAgICBjaXJjbGUoNTAwIC0geCwgNTAwIC0geSwgMTAwKTsKICAgICAgICAgIGNpcmNsZSgwICsgeCwgNTAwIC0geSwgMTAwKTsKICAgICAgICAgIGNpcmNsZSg1MDAgLSB4LCAwICsgeSwgMTAwKTsKICAgICAgICAgIAogICAgICAgICAgY2lyY2xlKDAgKyB4LCAwICsgeSwgMTApOwogICAgICAgICAgY2lyY2xlKDUwMCAtIHgsIDUwMCAtIHksIDEwKTsKICAgICAgICAgIGNpcmNsZSgwICsgeCwgNTAwIC0geSwgMTApOwogICAgICAgICAgY2lyY2xlKDUwMCAtIHgsIDAgKyB5LCAxMCk7CiAgICAgICAgfQogICAgICB9CiAgfQogIAogIGlmKCgodGltIC0gMCkgJSA1MjU2MDAwKSA+IDUxNjk2MDApewogICAgIGZpbHRlcihJTlZFUlQpOwogIH0KICAKfQoKZnVuY3Rpb24gcGVjKCl7CiAgbm9Mb29wKCk7CiAgYmFja2dyb3VuZCgiI0UxRTFFMSIpOwogIGJsZW5kTW9kZShNVUxUSVBMWSk7CiAgcmFuZG9tU2VlZChzZWVkKTsKICBsZXQgYXJyID0gW1swLDAsMCwwLDBdLFswLDAsMCwwLDBdLFswLDAsMCwwLDBdLFswLDAsMCwwLDBdLFswLDAsMCwwLDBdXTsKICBpZihhci50b1N0cmluZygpID09PSBhcnIudG9TdHJpbmcoKSl7CiAgICBzZWMoKTsKICB9IGVsc2UgewogICAgaWYoYXIgPT0gMCl7CiAgICAgIGZvcihsZXQgYSA9IDA7IGEgPCA1OyBhKz0xKXsKICAgICAgICBmb3IobGV0IGIgPTA7IGIgPCA1OyBiKz0xKXsKICAgICAgICAgIGFyclthXVtiXSA9IGZsb29yKHJhbmRvbSg1KSk7CiAgICAgICAgfQogICAgICB9CiAgICB9IGVsc2UgewogICAgICBhcnIgPSBhcjsKICAgIH0KICB9CiAgCiAgZm9yKGxldCBhID0gMDsgYSA8IDU7IGErPTEpewogICAgICBmb3IobGV0IGIgPTA7IGIgPCA1OyBiKz0xKXsKICAgICAgICBncyhhLGIsYXJyW2FdW2JdKTsKICAgICAgfQogIH0KICAKICBmaWx0ZXIoQkxVUiwgMSk7IAp9CgpmdW5jdGlvbiBzZWMoKXsKICBub0xvb3AoKTsKICBiYWNrZ3JvdW5kKDI1NSk7CiAgcmFuZG9tU2VlZChzZWVkKTsKICBibGVuZE1vZGUoTVVMVElQTFkpOwogIGZvcih2YXIgaSA9IDA7IGkgPD0gNTAwOyBpKz01KXsKICAgIGZvcih2YXIgaiA9IDA7IGogPD0gNTAwOyBqKz01KXsKICAgICAgZmlsbChyYW5kb20oZmxvb3IoMjU1KSksIHJhbmRvbShmbG9vcigyNTUpKSwgcmFuZG9tKGZsb29yKDI1NSkpKTsKICAgICAgc3Ryb2tlKHJhbmRvbShmbG9vcigyNTUpKSwgcmFuZG9tKGZsb29yKDI1NSkpLCByYW5kb20oZmxvb3IoMjU1KSkpOwogICAgICBjaXJjbGUoaSxqLGZsb29yKHJhbmRvbSg2LDEyKSkpOwogICAgfQogIH0KICBmaWx0ZXIoSU5WRVJUKTsKICBmaWx0ZXIoQkxVUiwgMSk7IAp9CgpmdW5jdGlvbiBzdGQoKXsKICBub0xvb3AoKTsKICBiYWNrZ3JvdW5kKCIjMUUxRTFFIik7CiAgc3Ryb2tlV2VpZ2h0KDEuMSk7CiAgc3Ryb2tlKDI1NSk7CiAgbm9pc2VTZWVkKHNlZWQpOwogIAogIGxldCB0ID0gMDsKICBmb3IobGV0IGkgPSA0MDAgLSBsdmw7IGkgPD0gNTAwOyBpKz01KXsKICAgIGZvcihsZXQgaiA9IDQwMCAtIGx2bDsgaiA8PSA1MDA7IGorPTUpewogICAgICAgIHBvaW50KGkgKiBub2lzZSh0KSwgaiAqIG5vaXNlKHQpKTsKICAgICAgICBwb2ludCg1MDAgLSAoaSAqIG5vaXNlKHQpKSwgaiAqIG5vaXNlKHQpKTsKICAgICAgICBwb2ludCg1MDAgLSAoaSAqIG5vaXNlKHQpKSwgNTAwIC0gKGogKiBub2lzZSh0KSkpOwogICAgICAgIHBvaW50KGkgKiBub2lzZSh0KSwgNTAwIC0gKGogKiBub2lzZSh0KSkpOwoKICAgICAgdCArPSAwLjA1OwogICAgfQogIH0KICAKICBpZihpbnYgPT0gMSl7CiAgICBmaWx0ZXIoSU5WRVJUKTsKICB9Cn0KCmZ1bmN0aW9uIGdzKHgsIHksIGMpIHsKICBsZXQgaTsKICBsZXQgajsKICAKICBpZihjID09IDEpewogICAgZm9yKGkgPSAxNSArICh4KjEwMCk7IGkgPD0gODUgKyAoeCoxMDApOyBpKz01KXsKICAgICAgZm9yKGogPSAxNSArICh5KjEwMCk7IGogPD0gODUgKyAoeSoxMDApOyBqKz01KXsKICAgICAgICBmaWxsKHJhbmRvbSgyNTUpKTsKICAgICAgICBzdHJva2UocmFuZG9tKDI1NSkpOwogICAgICAgIGNpcmNsZShpLGoscmFuZG9tKDYsMTIpKTsKICAgICAgfQogICAgfQogIH0KICAKICBpZihjID09IDIpewogICAgZm9yKGkgPSAxNSArICh4KjEwMCk7IGkgPD0gODUgKyAoeCoxMDApOyBpKz01KXsKICAgICAgZm9yKGogPSAxNSArICh5KjEwMCk7IGogPD0gODUgKyAoeSoxMDApOyBqKz01KXsKICAgICAgICBmaWxsKHJhbmRvbSgxOTIsIDI1NSksMCwwKTsKICAgICAgICBzdHJva2UocmFuZG9tKDE5MiwgMjU1KSwwLDApOwogICAgICAgIGNpcmNsZShpLGoscmFuZG9tKDYsMTIpKTsKICAgICAgfQogICAgfQogIH0KICAKICBpZihjID09IDMpewogICAgZm9yKGkgPSAxNSArICh4KjEwMCk7IGkgPD0gODUgKyAoeCoxMDApOyBpKz01KXsKICAgICAgZm9yKGogPSAxNSArICh5KjEwMCk7IGogPD0gODUgKyAoeSoxMDApOyBqKz01KXsKICAgICAgICBmaWxsKDAscmFuZG9tKDE5MiwgMjU1KSwwKTsKICAgICAgICBzdHJva2UoMCxyYW5kb20oMTkyLCAyNTUpLDApOwogICAgICAgIGNpcmNsZShpLGoscmFuZG9tKDYsMTIpKTsKICAgICAgfQogICAgfQogIH0KICAKICBpZihjID09IDQpewogICAgZm9yKGkgPSAxNSArICh4KjEwMCk7IGkgPD0gODUgKyAoeCoxMDApOyBpKz01KXsKICAgICAgZm9yKGogPSAxNSArICh5KjEwMCk7IGogPD0gODUgKyAoeSoxMDApOyBqKz01KXsKICAgICAgICBmaWxsKDAsMCxyYW5kb20oMTkyLCAyNTUpKTsKICAgICAgICBzdHJva2UoMCwwLHJhbmRvbSgxOTIsIDI1NSkpOwogICAgICAgIGNpcmNsZShpLGoscmFuZG9tKDYsMTIpKTsKICAgICAgfQogICAgfQogIH0KICAKICBpZihjID09IDUpewogICAgZm9yKGkgPSAxNSArICh4KjEwMCk7IGkgPD0gODUgKyAoeCoxMDApOyBpKz01KXsKICAgICAgZm9yKGogPSAxNSArICh5KjEwMCk7IGogPD0gODUgKyAoeSoxMDApOyBqKz01KXsKICAgICAgICBmaWxsKHJhbmRvbSgxOTIsIDI1NSkscmFuZG9tKDE5MiwgMjU1KSxyYW5kb20oMTkyLCAyNTUpKTsKICAgICAgICBzdHJva2UocmFuZG9tKDE5MiwgMjU1KSxyYW5kb20oMTkyLCAyNTUpLHJhbmRvbSgxOTIsIDI1NSkpOwogICAgICAgIGNpcmNsZShpLGoscmFuZG9tKDYsMTIpKTsKICAgICAgfQogICAgfQogIH0KfQoKZnVuY3Rpb24gZmluKCkgewogIGJhY2tncm91bmQoMCk7CiAgdGV4dFNpemUoMTgpOwogIHRleHRGb250KCdtb25vc3BhY2UnKTsKICB0ZXh0QWxpZ24oQ0VOVEVSKTsKICBmaWxsKDI1NSk7CiAgdGV4dCgnV2h5IGRvZXMgaXQgbWF0dGVyPycsIDI1MCwgMTMwKTsKICB0ZXh0KCdNYXR0ZXIgaXMgb2JzZXJ2YXRpb24uJywgMjUwLCAxNjUpOwogIHRleHQoJ1RoYW5rIHlvdSBmb3IgcGxheWluZyEnLCAyNTAsIDIwMCk7CiAgdGV4dCgnfnF1YXEnLCAyNTAsIDQwMCk7Cn0="></script>'
            );
    }

    function _page(
        Params memory _params
    ) internal view returns (string memory) {
        return
            string.concat(
                '"animation_url":"data:text/html;base64,',
                Base64.encode(
                    abi.encodePacked(
                        string.concat(
                            '<!DOCTYPE html><html style="height: 100%;"><head>',
                            _scripts(_params),
                            '</head><body style="margin: 0;display: flex;justify-content: center;align-items: center;height: 100%;"></body></html>'
                        )
                    )
                ),
                '",'
            );
    }

    function _attributes(
        Params memory _params
    ) internal pure returns (string memory) {
        string memory atr = string.concat(
            '"attributes": [{"trait_type": "Decay", "value": ',
            _params.lvl.toString(),
            "}, ",
            '{"display_type": "number","trait_type": "Prestige", "value": ',
            _params.pres.toString(),
            "}, "
        );

        atr = _params.inv > 0
            ? string.concat(atr, '{"trait_type": "Spin", "value": "Up"},')
            : string.concat(atr, '{"trait_type": "Spin", "value": "Down"},');

        atr = bytes(_params.ar).length > 1
            ? string.concat(atr, '{"trait_type": "Prism", "value": "Advanced"}')
            : string.concat(
                atr,
                '{"trait_type": "Prism", "value": "Original"}'
            );

        if (_params.asc > 0) {
            atr = string.concat(
                atr,
                ', {"trait_type": "[REDACTED]", "value": "[REDACTED]"}'
            );
        }

        if (_params.id < 1000 && _params.id % 111 == 0) {
            atr = string.concat(
                atr,
                ', {"trait_type": "Angel", "value": "',
                _params.id.toString(),
                '"}'
            );
        }

        if (_params.id % 1111 == 0) {
            atr = string.concat(
                atr,
                ', {"trait_type": "Hyper Angel", "value": "',
                _params.id.toString(),
                '"}'
            );
        }

        return string.concat(atr, "]");
    }

    function uri(Params memory _params) external view returns (string memory) {
        return
            string.concat(
                "data:application/json;base64,",
                Base64.encode(
                    abi.encodePacked(
                        string.concat(
                            '"name":">>> ',
                            _params.id.toString(),
                            ' <<<",',
                            desc,
                            '"image":"',
                            Particle._image(bytes32(_params.seed)),
                            '",',
                            _page(_params),
                            _attributes(_params)
                        )
                    )
                )
            );
    }
}
