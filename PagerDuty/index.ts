import * as pulumi from "@pulumi/pulumi";
import * as pagerduty from "@pulumi/pagerduty";

// Create a new user
const user = new pagerduty.User("exampleUser", {
    name: "John Doe",                     // Specify the name of the user
    email: "johndoe@example.com",        // Specify the email of the user
    role: "admin",                       // Set the role as 'admin'
    jobTitle: "DevOps Engineer",         // Specify the job title
    timeZone: "America/Los_Angeles",     // Specify the timezone
    color: "purple",                     // The color chosen for this user on schedules and more
    description: "Managed by Pulumi"     // A description to indicate the user management
});

// Create a new team
const team = new pagerduty.Team("team", {
    name: "Engineering",                // Specify the name of the team
    description: "All engineering",     // Specify the description of the team
});

// Create a new escalation policy
const policy = new pagerduty.EscalationPolicy("foo", {
    numLoops: 2,
    rules: [{
        escalationDelayInMinutes: 10,
        targets: [{
            type: "user_reference",
            id: user.id,
        }]
    }]
});

// Create escalation policy ID which is required for the service
let service = new pagerduty.Service("my-service", {
    escalationPolicy: "Escalation Policy ID here",
    autoResolveTimeout: "14400", // Auto resolve incidents after 4 hours
    acknowledgementTimeout: "1800", // Auto escalate incidents after 30 minutes
    name: "My Service" // Human friendly name
});
