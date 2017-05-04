#!/bin/bash

if [ -z "$1" ]; then
        echo "usage: APP ROLE"
        exit 1
fi
if [ -z "$2" ]; then
        echo "usage: APP ROLE"
        exit 1
fi

#$1 = Name of app
#$2 = Role (e.g Reader or Contributor)

#azure login

subscription_id=$(azure account list --json | jq -r '.[] | select(.isDefault) | .id')
tenant_id=$(azure account list --json | jq -r '.[] | select(.isDefault) | .tenantId')

echo "subscription_id: $subscription_id"
echo "tenant_id: $tenant_id"


client_secret=$(uuidgen)
create_app=$(azure ad app create --name "$1" --home-page "http://localhost/$1" --password "$client_secret" --identifier-uris "http://localhost/$1" --json)

app_id=$(echo $create_app | jq -r '.appId')
app_object_id=$(echo $create_app | jq -r '.objectId')

echo "app_id: $app_id"
echo "app_object_id: $app_object_id"

create_sp=$(azure ad sp create --applicationId $app_id --json)
service_principal_id=$(echo $create_sp | jq -r '.objectId')
client_id=$(echo $create_sp | jq -r '.servicePrincipalNames[0]')

echo "service_principal_id: $service_principal_id"
echo "client_id: $client_id"
echo "client_secret: $client_secret"

#wait for priniciple to be propagated
sleep 5

assign_role=$(azure role assignment create --objectId "$service_principal_id" --roleName "$2" --scope "/subscriptions/$subscription_id" --json)

role=$(echo $assign_role | jq -r '.properties.roleName')
echo "assigned role: $role"

echo
echo
echo "HANDY commands post run:"
echo
echo azure ad app delete -q --objectId $app_object_id
echo azure ad sp delete -q --objectId $service_principal_id
echo azure login --service-principal --username "$app_id" --password "$client_secret" --tenant "$tenant_id"

