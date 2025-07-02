public class ContactHandler {
    public static void updateAccountContactNames(List<Contact> newContacts, Map<Id, Contact> oldMap) {
        Set<Id> accountIds = new Set<Id>();

        // Add AccountIds from Trigger.new
        if (newContacts != null) {
            for (Contact c : newContacts) {
                if (c.AccountId != null) {
                    accountIds.add(c.AccountId);
                }
            }
        }

        // Add AccountIds from Trigger.oldMap
        if (oldMap != null) {
            for (Contact c : oldMap.values()) {
                if (c.AccountId != null) {
                    accountIds.add(c.AccountId);
                }
            }
        }

        if (!accountIds.isEmpty()) {
            // Query all related contacts
            Map<Id, List<String>> accountToContactNames = new Map<Id, List<String>>();

            for (Contact c : [
                SELECT Id, Name, AccountId
                FROM Contact
                WHERE AccountId IN :accountIds
            ]) {
                if (!accountToContactNames.containsKey(c.AccountId)) {
                    accountToContactNames.put(c.AccountId, new List<String>());
                }
                accountToContactNames.get(c.AccountId).add(c.Name);
            }

            // Create list of accounts to update
            List<Account> accountsToUpdate = new List<Account>();

            for (Id accountId : accountIds) {
                List<String> nameList = accountToContactNames.get(accountId);
                String concatenatedNames = (nameList != null && !nameList.isEmpty())
                    ? String.join(nameList, ', ')
                    : null;

                Account acc = new Account(
                    Id = accountId,
                    Concated_Contact_Names__c = concatenatedNames
                );

                accountsToUpdate.add(acc);
            }

            if (!accountsToUpdate.isEmpty()) {
                update accountsToUpdate;
            }
        }
    }
}