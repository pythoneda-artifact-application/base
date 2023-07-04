{
  description = "Application layer for pythoneda-artifact/git-tagging";

  inputs = rec {
    nixos.url = "github:NixOS/nixpkgs/nixos-23.05";
    flake-utils.url = "github:numtide/flake-utils/v1.0.0";
    pythoneda-base = {
      url = "github:pythoneda/base/0.0.1a15";
      inputs.nixos.follows = "nixos";
      inputs.flake-utils.follows = "flake-utils";
    };
    pythoneda-artifact-event-git-tagging = {
      url = "github:pythoneda-artifact-event/git-tagging/0.0.1a1";
      inputs.nixos.follows = "nixos";
      inputs.flake-utils.follows = "flake-utils";
      inputs.pythoneda-base.follows = "pythoneda-base";
    };
    pythoneda-artifact-event-infrastructure-git-tagging = {
      url =
        "github:pythoneda-artifact-event-infrastructure/git-tagging/0.0.1a1";
      inputs.nixos.follows = "nixos";
      inputs.flake-utils.follows = "flake-utils";
      inputs.pythoneda-base.follows = "pythoneda-base";
      inputs.pythoneda-artifact-event-git-tagging.follows =
        "pythoneda-artifact-event-git-tagging";
    };
    pythoneda-artifact-git-tagging = {
      url = "github:pythoneda-artifact/git-tagging/0.0.1a5";
      inputs.nixos.follows = "nixos";
      inputs.flake-utils.follows = "flake-utils";
      inputs.pythoneda-base.follows = "pythoneda-base";
      inputs.pythoneda-artifact-event-git-tagging.follows =
        "pythoneda-artifact-event-git-tagging";
    };
    pythoneda-infrastructure-base = {
      url = "github:pythoneda-infrastructure/base/0.0.1a11";
      inputs.nixos.follows = "nixos";
      inputs.flake-utils.follows = "flake-utils";
      inputs.pythoneda-base.follows = "pythoneda-base";
    };
    pythoneda-artifact-infrastructure-git-tagging = {
      url = "github:pythoneda-artifact-infrastructure/git-tagging/0.0.1a5";
      inputs.nixos.follows = "nixos";
      inputs.flake-utils.follows = "flake-utils";
      inputs.pythoneda-base.follows = "pythoneda-base";
      inputs.pythoneda-artifact-git-tagging.follows =
        "pythoneda-artifact-git-tagging";
      inputs.pythoneda-infrastructure-base.follows =
        "pythoneda-infrastructure-base";
    };
    pythoneda-application-base = {
      url = "github:pythoneda-application/base/0.0.1a11";
      inputs.nixos.follows = "nixos";
      inputs.flake-utils.follows = "flake-utils";
      inputs.pythoneda-base.follows = "pythoneda-base";
      inputs.pythoneda-infrastructure-base.follows =
        "pythoneda-infrastructure-base";
    };
    pythoneda-shared-git = {
      url = "github:pythoneda-shared/git/0.0.1a2";
      inputs.nixos.follows = "nixos";
      inputs.flake-utils.follows = "flake-utils";
      inputs.pythoneda-base.follows = "pythoneda-base";
    };
  };
  outputs = inputs:
    with inputs;
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixos { inherit system; };
        description = "Application layer for pythoneda-artifact/git-tagging";
        license = pkgs.lib.licenses.gpl3;
        homepage =
          "https://github.com/pythoneda-artifact-application/git-tagging";
        maintainers = with pkgs.lib.maintainers; [ ];
        nixpkgsRelease = "nixos-23.05";
        shared = import ./nix/devShells.nix;
        pythoneda-artifact-application-git-tagging-for = { version
          , pythoneda-base, pythoneda-artifact-event-git-tagging
          , pythoneda-artifact-event-infrastructure-git-tagging
          , pythoneda-artifact-git-tagging, pythoneda-infrastructure-base
          , pythoneda-artifact-infrastructure-git-tagging
          , pythoneda-application-base, pythoneda-shared-git, python }:
          let
            pname = "pythoneda-artifact-application-git-tagging";
            pythonVersionParts = builtins.splitVersion python.version;
            pythonMajorVersion = builtins.head pythonVersionParts;
            pythonMajorMinorVersion =
              "${pythonMajorVersion}.${builtins.elemAt pythonVersionParts 1}";
            pnameWithUnderscores =
              builtins.replaceStrings [ "-" ] [ "_" ] pname;
            wheelName =
              "${pnameWithUnderscores}-${version}-py${pythonMajorVersion}-none-any.whl";
          in python.pkgs.buildPythonPackage rec {
            inherit pname version;
            projectDir = ./.;
            src = ./.;
            format = "pyproject";

            nativeBuildInputs = with python.pkgs; [ pip pkgs.jq poetry-core ];
            propagatedBuildInputs = with python.pkgs; [
              dbus-next
              GitPython
              grpcio
              pythoneda-base
              pythoneda-artifact-event-git-tagging
              pythoneda-artifact-event-infrastructure-git-tagging
              pythoneda-artifact-git-tagging
              pythoneda-infrastructure-base
              pythoneda-application-base
              pythoneda-artifact-infrastructure-git-tagging
              pythoneda-shared-git
              requests
            ];

            checkInputs = with python.pkgs; [ pytest ];

            pythonImportsCheck = [ "pythonedaartifactapplicationgittagging" ];

            preBuild = ''
              python -m venv .env
              source .env/bin/activate
              pip install ${pythoneda-base}/dist/pythoneda_base-${pythoneda-base.version}-py3-none-any.whl
              pip install ${pythoneda-artifact-event-git-tagging}/dist/pythoneda_artifact_event_git_tagging-${pythoneda-artifact-event-git-tagging.version}-py3-none-any.whl
              pip install ${pythoneda-artifact-event-infrastructure-git-tagging}/dist/pythoneda_artifact_event_infrastructure_git_tagging-${pythoneda-artifact-event-infrastructure-git-tagging.version}-py3-none-any.whl
              pip install ${pythoneda-artifact-git-tagging}/dist/pythoneda_artifact_git_tagging-${pythoneda-artifact-git-tagging.version}-py3-none-any.whl
              pip install ${pythoneda-infrastructure-base}/dist/pythoneda_infrastructure_base-${pythoneda-infrastructure-base.version}-py3-none-any.whl
              pip install ${pythoneda-artifact-infrastructure-git-tagging}/dist/pythoneda_artifact_infrastructure_git_tagging-${pythoneda-artifact-infrastructure-git-tagging.version}-py3-none-any.whl
              pip install ${pythoneda-application-base}/dist/pythoneda_application_base-${pythoneda-application-base.version}-py3-none-any.whl
              pip install ${pythoneda-shared-git}/dist/pythoneda_shared_git-${pythoneda-shared-git.version}-py3-none-any.whl
              rm -rf .env
            '';

            postInstall = ''
              mkdir $out/dist
              cp dist/${wheelName} $out/dist
              jq ".url = \"$out/dist/${wheelName}\"" $out/lib/python${pythonMajorMinorVersion}/site-packages/${pnameWithUnderscores}-${version}.dist-info/direct_url.json > temp.json && mv temp.json $out/lib/python${pythonMajorMinorVersion}/site-packages/${pnameWithUnderscores}-${version}.dist-info/direct_url.json
            '';

            meta = with pkgs.lib; {
              inherit description homepage license maintainers;
            };
          };
        pythoneda-artifact-application-git-tagging-0_0_1a6-for =
          { pythoneda-base, pythoneda-artifact-event-git-tagging
          , pythoneda-artifact-event-infrastructure-git-tagging
          , pythoneda-artifact-git-tagging, pythoneda-infrastructure-base
          , pythoneda-artifact-infrastructure-git-tagging
          , pythoneda-application-base, pythoneda-shared-git, python }:
          pythoneda-artifact-application-git-tagging-for {
            version = "0.0.1a6";
            inherit pythoneda-base pythoneda-artifact-event-git-tagging
              pythoneda-artifact-event-infrastructure-git-tagging
              pythoneda-artifact-git-tagging pythoneda-infrastructure-base
              pythoneda-artifact-infrastructure-git-tagging
              pythoneda-application-base pythoneda-shared-git python;
          };
      in rec {
        packages = rec {
          pythoneda-artifact-application-git-tagging-0_0_1a6-python39 =
            pythoneda-artifact-application-git-tagging-0_0_1a6-for {
              pythoneda-base =
                pythoneda-base.packages.${system}.pythoneda-base-latest-python39;
              pythoneda-artifact-event-git-tagging =
                pythoneda-artifact-event-git-tagging.packages.${system}.pythoneda-artifact-event-git-tagging-latest-python39;
              pythoneda-artifact-event-infrastructure-git-tagging =
                pythoneda-artifact-event-infrastructure-git-tagging.packages.${system}.pythoneda-artifact-event-infrastructure-git-tagging-latest-python39;
              pythoneda-artifact-git-tagging =
                pythoneda-artifact-git-tagging.packages.${system}.pythoneda-artifact-git-tagging-latest-python39;
              pythoneda-infrastructure-base =
                pythoneda-infrastructure-base.packages.${system}.pythoneda-infrastructure-base-latest-python39;
              pythoneda-artifact-infrastructure-git-tagging =
                pythoneda-artifact-infrastructure-git-tagging.packages.${system}.pythoneda-artifact-infrastructure-git-tagging-latest-python39;
              pythoneda-application-base =
                pythoneda-application-base.packages.${system}.pythoneda-application-base-latest-python39;
              pythoneda-shared-git =
                pythoneda-shared-git.packages.${system}.pythoneda-shared-git-latest-python39;
              python = pkgs.python39;
            };
          pythoneda-artifact-application-git-tagging-0_0_1a6-python310 =
            pythoneda-artifact-application-git-tagging-0_0_1a6-for {
              pythoneda-base =
                pythoneda-base.packages.${system}.pythoneda-base-latest-python310;
              pythoneda-artifact-event-git-tagging =
                pythoneda-artifact-event-git-tagging.packages.${system}.pythoneda-artifact-event-git-tagging-latest-python310;
              pythoneda-artifact-event-infrastructure-git-tagging =
                pythoneda-artifact-event-infrastructure-git-tagging.packages.${system}.pythoneda-artifact-event-infrastructure-git-tagging-latest-python310;
              pythoneda-artifact-git-tagging =
                pythoneda-artifact-git-tagging.packages.${system}.pythoneda-artifact-git-tagging-latest-python310;
              pythoneda-infrastructure-base =
                pythoneda-infrastructure-base.packages.${system}.pythoneda-infrastructure-base-latest-python310;
              pythoneda-artifact-infrastructure-git-tagging =
                pythoneda-artifact-infrastructure-git-tagging.packages.${system}.pythoneda-artifact-infrastructure-git-tagging-latest-python310;
              pythoneda-application-base =
                pythoneda-application-base.packages.${system}.pythoneda-application-base-latest-python310;
              pythoneda-shared-git =
                pythoneda-shared-git.packages.${system}.pythoneda-shared-git-latest-python310;
              python = pkgs.python310;
            };
          pythoneda-artifact-application-git-tagging-latest-python39 =
            pythoneda-artifact-application-git-tagging-0_0_1a6-python39;
          pythoneda-artifact-application-git-tagging-latest-python310 =
            pythoneda-artifact-application-git-tagging-0_0_1a6-python310;
          pythoneda-artifact-application-git-tagging-latest =
            pythoneda-artifact-application-git-tagging-latest-python310;
          default = pythoneda-artifact-application-git-tagging-latest;
        };
        defaultPackage = packages.default;
        devShells = rec {
          pythoneda-artifact-application-git-tagging-0_0_1a6-python39 =
            shared.devShell-for {
              package =
                packages.pythoneda-artifact-application-git-tagging-0_0_1a6-python39;
              pythoneda-base =
                pythoneda-base.packages.${system}.pythoneda-base-latest-python39;
              python = pkgs.python39;
              inherit pkgs nixpkgsRelease;
            };
          pythoneda-artifact-application-git-tagging-0_0_1a6-python310 =
            shared.devShell-for {
              package =
                packages.pythoneda-artifact-application-git-tagging-0_0_1a6-python310;
              pythoneda-base =
                pythoneda-base.packages.${system}.pythoneda-base-latest-python310;
              python = pkgs.python310;
              inherit pkgs nixpkgsRelease;
            };
          pythoneda-artifact-application-git-tagging-latest-python39 =
            pythoneda-artifact-application-git-tagging-0_0_1a6-python39;
          pythoneda-artifact-application-git-tagging-latest-python310 =
            pythoneda-artifact-application-git-tagging-0_0_1a6-python310;
          pythoneda-artifact-application-git-tagging-latest =
            pythoneda-artifact-application-git-tagging-latest-python310;
          default = pythoneda-artifact-application-git-tagging-latest;

        };
      });
}
