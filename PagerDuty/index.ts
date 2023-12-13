import * as pulumi from "@pulumi/pulumi";
import * as pagerduty from "@pulumi/pagerduty";

const exampleUser = new pagerduty.User("exampleUser", {email: "125.greenholt.earline@graham.name"});
// not in use currently
// const exampleUser = new pagerduty.User("exampleUser", {email: "125.greenholt.earline@graham.name"});
const foo = new pagerduty.EscalationPolicy("foo", {
    numLoops: 2,
    rules: [{
        escalationDelayInMinutes: 10,
        targets: [{
            type: "user_reference",
            id: exampleUser.id,
        }]
    }]
});