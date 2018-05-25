Sometimes you have a certain action (web or background) that you don't need to log to AppSignal. The most common use case is an action that your load balancer uses to check if your app is still responding.

You can ignore these actions from being sent to AppSignal in the [configuration](index.html). This works both for controller actions and for background workers. The action names listed should match with the action names that are reported in your app in the AppSignal.com UI.

Ignoring actions will **ignore all transaction data** from this action. No errors and performance issues will be reported for these actions. [Custom metrics](/metrics/custom.html) recorded in this action will still be reported.
