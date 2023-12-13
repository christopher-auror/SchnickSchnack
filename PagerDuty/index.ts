import * as pulumi from "@pulumi/pulumi";
import * as pagerduty from "@pulumi/pagerduty";

const exampleUser = new pagerduty.User("exampleUser", {email: "125.greenholt.earline@graham.name"}); // generates a new licensed user
const foo = new pagerduty.EscalationPolicy("foo", { //generates a new escalation policy
    numLoops: 2,
    rules: [{
        escalationDelayInMinutes: 10,
        targets: [{
            type: "user_reference",
            id: exampleUser.id,
        }]
    }]
});

// Provide the Escalation Policy ID which is required for the service
let service = new pagerduty.Service("my-service", {
    escalationPolicy: "Escalation Policy ID here",
    autoResolveTimeout: "14400", // Auto resolve incidents after 4 hours
    acknowledgementTimeout: "1800", // Auto escalate incidents after 30 minutes
    name: "My Service" // Human friendly name
});

// Confirm the ID of the service created for future reference if needed
export const serviceId = service.id;
