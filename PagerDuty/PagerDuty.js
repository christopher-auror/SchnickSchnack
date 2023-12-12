import * as pulumi from "@pulumi/pulumi";
import * as pagerduty from "@pulumi/pagerduty";

const demoTeam = new pagerduty.Team("demo-team", {
    description: "Demo team generated from examples",
});

