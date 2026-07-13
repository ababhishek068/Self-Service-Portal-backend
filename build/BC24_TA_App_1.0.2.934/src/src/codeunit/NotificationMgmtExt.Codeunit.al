codeunit 50046 "Notification Mgmt Ext"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Notification Management", 'OnGetDocumentTypeAndNumber', '', false, false)]
    local procedure AddCustomTablesOnGetDocumentTypeAndNumber(var RecRef: RecordRef; var DocumentType: Text; var DocumentNo: Text; var IsHandled: Boolean)
    var
        // PaymentsHeader: Record "Payments Header";    
        FieldRef: FieldRef;
    begin
        case RecRef.Number of
            DATABASE::"Payments Header":
                begin
                    DocumentType := RecRef.Caption;
                    FieldRef := RecRef.Field(1);
                    DocumentNo := Format(FieldRef.Value);
                    IsHandled := true;
                end;
            Database::"Imprest Header":
                begin
                    DocumentType := RecRef.Caption;
                    FieldRef := RecRef.Field(1);
                    DocumentNo := Format(FieldRef.Value);
                    IsHandled := true;
                end;


        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnBeforeCreateNotificationEntry', '', false, false)]
    local procedure "Workflow Response Handling_OnBeforeCreateNotificationEntry"(WorkflowStepInstance: Record "Workflow Step Instance"; ApprovalEntry: Record "Approval Entry"; var IsHandled: Boolean)
    begin
    end;


}
