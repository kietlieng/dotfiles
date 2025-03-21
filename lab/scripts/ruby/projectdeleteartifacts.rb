projectList = [

'development/automation/test-cases/web/main-ui',
'development/application/pac-classic/evenue/PacMon',
'development/application/integration/mobile/mSDK V5',
'development/application/cart/cart-ms/cart-ms-checkout Deprecated',
'development/automation/test-cases/web/nightwatch-pac-live-e2e',
'development/application/pac-classic/pac8',
'development/application/ticketing/javascript/evenue-next/Next Checkout/next-checkout',
'development/application/ticketing/javascript/evenue-next/Universal Sign In/usi-module',
'development/application/integration/api/google-pay-passes',
'development/application/ticketing/javascript/serverless/apple-pass-lambda',
'development/application/fundraising/fund-consumer-microservice',
'development/application/ticketing/javascript/evenue-next/Next Event Detail/next-event-detail',
'development/application/ticketing/javascript/evenue-next/Next My Account/next-my-account',
'development/application/pac-classic/evenue/web',
'development/application/ticketing/seat-mgmt/seat-mgmt-ui',
'development/application/ticketing/javascript/evenue-next/Next Event List/next-event-list',
'development/application/fundraising/fund-core/fund-core-app',
'development/application/payment/deprecated/Payment MS',
'development/application/TicketDeliveryService/Consumer/ticket-delivery-app',
'development/application/ticketing/javascript/evenue-next/Next Event Detail/next-event-detail-base-component',
'development/application/pac-classic/pac8-inv',
'development/application/fundraising/React/remote-components/Transaction Entry Remote Component',
'development/application/pac-classic/pac8-pfs',
'development/application/ticketing/javascript/evenue-next/evenue-next-document-component',
'development/application/ticketing/javascript/evenue-next/Next Cart/next-cart',
'development/application/ticketing/javascript/evenue-next/Next Event Detail/next-event-detail-page',
'development/application/integration/api/entry-service',
'development/application/ticketing/javascript/evenue-next/Next Order Confirmation',
'development/application/ticketing/javascript/orders-nightwatch',
'development/application/payment/payment-ms',
'development/application/integration/mobile/mpac',
'development/application/ticketing/javascript/evenue-next/Next My Account/next-my-account-login',
'development/application/fundraising/ranking-ms/ranking-service',
'development/automation/library/javascript/nightwatch/pacwatch',
'development/automation/library/javascript/tools/pac-qa-tools',
'development/pac-common/javascript/React/react-base-components',
'development/application/ticketing/javascript/serverless/order-scheduler-services/order-scheduler-service',
'development/application/cart/vendor-lambdas/insurance-lambdas',
'development/application/integration/api/timed-entry/timed-entry-lambdas',

]

projectList.each do |currentProject|

  puts currentProject
  project = Project.find_by_full_path(currentProject)
  builds_with_artifacts =  project.builds.with_downloadable_artifacts
  builds_with_artifacts.where("finished_at < ?", 6.months.ago).each_batch do |batch|
   batch.each do |build|
     Ci::JobArtifacts::DeleteService.new(build).execute
   end

   batch.update_all(artifacts_expire_at: Time.current)
  end

end
