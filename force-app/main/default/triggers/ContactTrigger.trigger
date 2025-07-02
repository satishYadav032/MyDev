/* Sandbox : UserName : test-mpkpcemto7l9@example.com
    PASSWORD : Satish@2025
    Created Date : 2023-10-04 12:00:00
    Created By : Satosh Yadav 
    Last Modified Date : 2023-10-04 12:00:00
    Last Modified By : Satosh Yadav
    Description : Trigger to handle before insert operations on Contact object
    */

/*You have a text field on the Account object that should always show the 
 concatenated names of all related Contacts.Ensure that whenever a Contact is added, updated,
 or deleted, the Account's text field is updated to reflect the concatenated names of its Contacts.
*/

trigger ContactTrigger on Contact (after insert, after update, after delete, after undelete) {
    if (Trigger.isAfter) {
        if (Trigger.isInsert || Trigger.isUndelete) {
            ContactHandler.updateAccountContactNames(Trigger.new, null);
        }
        else if (Trigger.isUpdate || Trigger.isDelete) {
            ContactHandler.updateAccountContactNames(Trigger.new, Trigger.oldMap);
        }
    }
}