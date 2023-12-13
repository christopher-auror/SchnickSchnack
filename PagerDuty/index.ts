import * as pulumi from "@pulumi/pulumi";
import * as pagerduty from "@pulumi/pagerduty";

const user = new pagerduty.User("my-user", {
    name: "John Doe",                     // Specify the name of the user.
    email: "johndoe@example.com",        // Specify the email of the user.
    role: "admin",                       // Set the role as 'admin'.
    jobTitle: "DevOps Engineer",         // Specify the job title.
    timeZone: "America/Los_Angeles",     // Specify the timezone.
    color: "purple",                     // The color chosen for this user on schedules and more.
    description: "Managed by Pulumi"     // A description to indicate the user management.
});

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
