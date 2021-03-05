# Unity - Runner
[![CI](https://github.com/MirrorNG/unity-runner/workflows/CI/badge.svg)](https://github.com/MirrorNG/unity-runner/actions?query=workflow%3ACI)

---

GitHub Action to 
[run unity](https://github.com/marketplace/actions/unity-runner) 
for any Unity project. 

This Action also includes [SonarScanner](https://docs.sonarqube.org/latest/analysis/scan/sonarscanner/) and [DocFX](https://dotnet.github.io/docfx/) installs

---

## Usage

Create or edit the file called `.github/workflows/main.yml` and add a request activation file job

```yaml
name: Test project
on: [push]
jobs:
  requestActivationFile:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout repository
        uses: actions/checkout@v2

      - name: Request manual activation file
        uses: MirrorNG/unity-runner@3.1.0
        id: getManualLicenseFile
        with:
            entrypoint: /request_activation.sh

      - name: Expose as artifact
        uses: actions/upload-artifact@v1
        with:
            name: Manual Activation File
            path: ${{ steps.getManualLicenseFile.outputs.filePath }}
```

Commit and push this so it runs once. This will generate a manual activation license request file.  Save this file and upload it to https://license.unity3d.com/manual

That will generate a license file for personal.  Go back to your github project and navigate to Settings -> Secrets

create a secret called UNITY_LICENSE and paste inside the content of the license file.

You can disable the job by adding `if: false()` or commenting it out, you only needed it to generate the license.

Add a job to run unity cli on your project.  You will need a step to activate unity and another step to run unity with any command line argument you want.  For example:

```yaml
jobs:
  testRunnerInEditMode:
    name: Test edit mode 📝
    runs-on: ubuntu-latest
    env:
      UNITY_LICENSE: ${{ secrets.UNITY_LICENSE }}   
    steps:
      # Checkout repository (required to test local actions)
      - name: Checkout repository
        uses: actions/checkout@v2

      - name: Activate license
        uses: MirrorNG/unity-runner@3.1.0
        with:
          entrypoint: /activate.sh

      - name: Run tests
        uses: MirrorNG/unity-runner@3.1.0
        with:
          args: -runTests -projectPath .
```

See the [Unity's documentation](https://docs.unity3d.com/Manual/CommandLineArguments.html) for a full list of all available argument options.
