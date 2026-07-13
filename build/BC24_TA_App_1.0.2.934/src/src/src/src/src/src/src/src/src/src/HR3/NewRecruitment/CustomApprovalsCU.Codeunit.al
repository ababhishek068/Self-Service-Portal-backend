codeunit 50002 "Custom Approvals CU"
{

    trigger OnRun();
    begin
    end;

    var
        WorkflowManagement: Codeunit "Workflow Management";
        UnsupportedRecordTypeErr: Label 'Record type %1 is not supported by this workflow response.', Comment = 'Record type Customer is not supported by this workflow response.';
        NoWorkflowEnabledErr: Label 'This record is not supported by related approval workflow.';

        OnSend_LEAVE_APPLICATION_ApprovalRequest_Txt: Label 'Approval of a LEAVE_APPLICATION is requested';
        RunWorkflowOnSend_LEAVE_APPLICATION_ForApprovalCode_Txt: Label 'RUNWORKFLOWONSEND_LEAVE_APPLICATION_FORAPPROVAL';
        OnCancel_LEAVE_APPLICATION_ApprovalRequestTxt: Label 'An Approval of a LEAVE_APPLICATION is canceled';
        RunWorkflowOnCancel_LEAVE_APPLICATION_ForApprovalCode_Txt: Label 'RUNWORKFLOWONCANCEL_LEAVE_APPLICATION_FORAPPROVAL';


    procedure CheckApprovalsWorkflowEnabled(var Variant: Variant): Boolean;
    var
        RecRef: RecordRef;
    //WorkflowEventHandling: Codeunit "Workflow Event Handling";
    begin
        RecRef.GETTABLE(Variant);
        CASE RecRef.NUMBER() OF


            //LEAVE_APPLICATION
            DATABASE::"HR Leave Application":
                EXIT(CheckApprovalsWorkflowEnabledCode(Variant, RunWorkflowOnSend_LEAVE_APPLICATION_ForApprovalCode_Txt));

            ELSE
                ERROR(UnsupportedRecordTypeErr, RecRef.CAPTION());
        END;
    end;

    procedure CheckApprovalsWorkflowEnabledCode(var Variant: Variant; CheckApprovalsWorkflowTxt: Text): Boolean;
    var
    //RecRef: RecordRef;
    //WorkflowEventHandling: Codeunit "Workflow Event Handling";
    begin
        BEGIN
            IF NOT WorkflowManagement.CanExecuteWorkflow(Variant, copystr(CheckApprovalsWorkflowTxt, 1, 128)) THEN
                ERROR(NoWorkflowEnabledErr);
            EXIT(TRUE);
        END;
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendDocForApproval(var Variant: Variant);
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelDocApprovalRequest(var Variant: Variant);
    begin
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventsToLibrary', '', false, false)]
    local procedure AddWorkflowEventsToLibrary();
    var
        WorkFlowEventHandling: Codeunit "Workflow Event Handling";
    begin

        //Jobs
        WorkFlowEventHandling.AddEventToLibrary(copystr(RunWorkflowOnSend_LEAVE_APPLICATION_ForApprovalCode_Txt, 1, 128),
                                                 DATABASE::"HR Leave Application",
                                                  copystr(OnSend_LEAVE_APPLICATION_ApprovalRequest_Txt, 1, 128), 0, FALSE);

        WorkFlowEventHandling.AddEventToLibrary(copystr(RunWorkflowOnCancel_LEAVE_APPLICATION_ForApprovalCode_Txt, 1, 128),
                                                DATABASE::"HR Leave Application",
                                                copystr(OnCancel_LEAVE_APPLICATION_ApprovalRequestTxt, 1, 250), 0, FALSE);


    end;

    local procedure RunWorkflowOnSendApprovalRequestCode(): Code[128];
    begin
        EXIT(copystr(UPPERCASE('RunWorkflowOnSendApprovalRequest'), 1, 128));
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Custom Approvals CU", 'OnSendDocForApproval', '', false, false)]
    procedure RunWorkflowOnSendApprovalRequest(var Variant: Variant);
    var
        RecRef: RecordRef;
    begin
        RecRef.GETTABLE(Variant);
        CASE RecRef.NUMBER() OF

            //Jobs
            DATABASE::"HR Leave Application":
                WorkflowManagement.HandleEvent(RunWorkflowOnSend_LEAVE_APPLICATION_ForApprovalCode_Txt, Variant);
            ELSE
                ERROR(UnsupportedRecordTypeErr, RecRef.CAPTION());
        END;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Custom Approvals CU", 'OnCancelDocApprovalRequest', '', false, false)]
    procedure RunWorkflowOnCancelApprovalRequest(var Variant: Variant);
    var
        RecRef: RecordRef;
    begin
        RecRef.GETTABLE(Variant);
        CASE RecRef.NUMBER() OF

            //Jobs
            DATABASE::"HR Leave Application":
                WorkflowManagement.HandleEvent(RunWorkflowOnCancel_LEAVE_APPLICATION_ForApprovalCode_Txt, Variant);

            ELSE
                ERROR(UnsupportedRecordTypeErr, RecRef.CAPTION());
        END;
    end;

    procedure ReOpen(var Variant: Variant);
    var
        RecRef: RecordRef;

        HRLeaveApp: Record "HR Leave Application";

    begin
        RecRef.GETTABLE(Variant);
        CASE RecRef.NUMBER() OF


            //Jobs
            DATABASE::"HR Leave Application":
                BEGIN
                    RecRef.SETTABLE(HRLeaveApp);
                    HRLeaveApp.VALIDATE(Status, HRLeaveApp.Status::Rejected);
                    HRLeaveApp.MODIFY;
                    Variant := HRLeaveApp;
                END;

            ELSE
                ERROR(UnsupportedRecordTypeErr, RecRef.CAPTION());
        END
    end;

    procedure Release(var Variant: Variant);
    var
        RecRef: RecordRef;

        HRLeaveApp: Record "HR Leave Application";

    begin
        RecRef.GETTABLE(Variant);
        CASE RecRef.NUMBER() OF

            //HR Leave Application
            DATABASE::"HR Leave Application":
                BEGIN
                    RecRef.SETTABLE(HRLeaveApp);
                    HRLeaveApp.VALIDATE(Status, HRLeaveApp.Status::Approved);
                    HRLeaveApp.MODIFY;
                    Variant := HRLeaveApp;
                END;

            ELSE
                ERROR(UnsupportedRecordTypeErr, RecRef.CAPTION());
        END;
    end;

    procedure SetStatusToPending(var Variant: Variant);
    var
        RecRef: RecordRef;

        HRLeaveApp: Record "HR Leave Application";

    begin
        RecRef.GETTABLE(Variant);
        CASE RecRef.NUMBER() OF

            //HR Leave Application
            DATABASE::"HR Leave Application":
                BEGIN
                    RecRef.SETTABLE(HRLeaveApp);
                    HRLeaveApp.VALIDATE(Status, HRLeaveApp.Status::"Pending Approval");
                    HRLeaveApp.MODIFY;
                    Variant := HRLeaveApp;
                END;


            ELSE
                ERROR(UnsupportedRecordTypeErr, RecRef.CAPTION());
        END
    end;

    procedure HasOpenApprovalEntries(RecordID: RecordID): Boolean;
    var
        ApprovalEntry: Record "Approval Entry";
    begin
        ApprovalEntry.SETRANGE("Table ID", RecordID.TABLENO());
        ApprovalEntry.SETRANGE("Record ID to Approve", RecordID);
        ApprovalEntry.SETRANGE(Status, ApprovalEntry.Status::Open);
        ApprovalEntry.SETRANGE("Related to Change", FALSE);
        EXIT(NOT ApprovalEntry.ISEMPTY());
    end;

    procedure OpenApprovalEntriesPage(RecId: RecordID);
    var
        ApprovalEntry: Record "Approval Entry";
    begin
        ApprovalEntry.SETRANGE("Table ID", RecId.TABLENO());
        ApprovalEntry.SETRANGE("Record ID to Approve", RecId);
        ApprovalEntry.SETRANGE("Related to Change", FALSE);
        // PAGE.RUNMODAL(PAGE::"Approval Entries", ApprovalEntry);
    end;

    procedure HasOpenApprovalEntriesForCurrentUser(RecordID: RecordID): Boolean;
    var
        ApprovalEntry: Record "Approval Entry";
    begin
        EXIT(FindOpenApprovalEntryForCurrUser(ApprovalEntry, RecordID));
    end;

    procedure FindOpenApprovalEntryForCurrUser(var ApprovalEntry: Record "Approval Entry"; RecordID: RecordID): Boolean;
    begin
        ApprovalEntry.SETRANGE("Table ID", RecordID.TABLENO());
        ApprovalEntry.SETRANGE("Record ID to Approve", RecordID);
        ApprovalEntry.SETRANGE(Status, ApprovalEntry.Status::Open);
        ApprovalEntry.SETRANGE("Approver ID", USERID());
        ApprovalEntry.SETRANGE("Related to Change", FALSE);

        EXIT(ApprovalEntry.FINDFIRST());
    end;
}
