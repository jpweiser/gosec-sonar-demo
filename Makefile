############################################################
# gosec
#
# Installs latest release of gosec, then runs gosec in
# quiet mode (meaning output only if issues found)
#
# In the case of go/gosec rule, use this to test locally, or
# if not using SonarCloud in the build system. 
# Please use SonarCloud.
# This will print findings to stdout, and break the build
# when any findings are present
############################################################

.PHONY: go/gosec-install
go/gosec-install:
	curl -sfL https://raw.githubusercontent.com/securego/gosec/master/install.sh | sh -s -- -b $(GOPATH)/bin

.PHONY: go/gosec
go/gosec: go/gosec-install
	gosec --quiet ./...

.PHONY: sonar/go
## Run SonarCloud analysis for Go. This will generally be run as part of a Travis build, not during local development.

# Installs latest release of gosec, then runs gosec in quiet mode (meaning output only if issues found)

# For sonar/go rule, gosec output is saved and formatted for sonarqube/sonarcloud. This will require the line
# sonar.externalIssuesReportPaths="gosec.json" in your sonar-project.properties file to be consumed by the tool

sonar/go: go/gosec-install
	go test -coverprofile=coverage.out -json ./... > report.json
	gosec --quiet -fmt sonarqube -out gosec.json -no-fail ./...
	sonar-scanner --debug