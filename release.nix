{ mflowSrc ? {outPath = ./.; revCount=0; gitTag = "dirty"; }
}:
let
    pkgs = import <nixpkgs> {};
    haskellPackages = pkgs.haskellPackages_ghc782;
    jobs = rec {
        mflowCabal = haskellPackages.cabal.mkDerivation (self: {
            pname = "MFlow";
            src = mflowSrc;
            version = mflowSrc.gitTag;
            isLibrary = true;
            buildDepends = with haskellPackages; [
                blazeHtml blazeMarkup caseInsensitive clientsession conduit
                conduitExtra extensibleExceptions httpTypes monadloc mtl parsec
                random RefSerialize stm TCache text time transformers utf8String
                vector wai warp warpTls Workflow
                ];
            buildTools = with haskellPackages; [ cpphs ];

            meta = {
                description = "stateful, RESTful web framework";
                license = self.stdenv.lib.licenses.bsd3;
                platforms = self.ghc.meta.platforms;
                maintainers = [ self.stdenv.lib.maintainers.tomberek ];
            };
        });
    };
in jobs

