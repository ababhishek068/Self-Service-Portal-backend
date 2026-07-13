Page 50653 "Litigation Card"
{
    PageType = Card;
    SourceTable = "Legal Management";
    Caption = 'Legal and ADRs';
    ApplicationArea = All;
    layout
    {
        area(content)
        {
            group(General)
            {
                field(No; Rec.No)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the No field.';
                }
                field(Requestdate; Rec."Request date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Request date field.';
                }
                field(RequiredDate; Rec."Required Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Required Date field.';
                }
                field(LitigationStatus; Rec."Litigation Status")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Litigation Status field.';
                }
                field(Name; Rec."Visitor Name")
                {
                    ApplicationArea = Basic;
                    Caption = 'Name';
                    ToolTip = 'Specifies the value of the Name field.';
                }
                field(IDNumber; Rec."ID Number")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the ID Number field.';
                }
                field(Department; Rec.Department)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Department field.';
                }
                field(PhoneNumber; Rec."Phone Number")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Phone Number field.';
                }
                field(Description; Rec."Purpose of Visit")
                {
                    ApplicationArea = Basic;
                    Caption = 'Description';
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(GlobalDimension1Code; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.';
                }
                field(FunctionName; Rec."Function Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Function Name field.';
                }
                field(ShortcutDimension2Code; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 2 Code field.';
                }
                field(ResponsibilityCenter; Rec."Budget Center Name")
                {
                    ApplicationArea = Basic;
                    Caption = 'Responsibility Center';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Responsibility Center field.';
                }
                field(MeetingHeld; Rec."Meeting Held?")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Meeting Held? field.';
                }
                field(MeetingScheduleDate; Rec."Meeting Schedule Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Meeting Schedule Date field.';
                }
                field("Resolution Type"; Rec."Resolution Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Recommendation field.';
                }
                field(ConcernedDepartmentNotified; Rec."Concerned Department Notified")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Concerned Department Notified field.';
                }
                field("Assigned to"; Rec."Assigned to")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Assigned to field.';
                }
                field(DocumentsAttached; Rec."Documents Attached?")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Documents Attached? field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field(InitiatedBy; Rec."Initiated By")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Initiated By field.';
                }
                field(ClearedBy; Rec."Cleared By")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Cleared By field.';
                }
                field(IssueDate; Rec."Issue Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Issue Date field.';
                }
            }
            group(Details)
            {
                Caption = 'Feedback';
                field(Feedback; Rec.Feedback)
                {
                    Caption = 'Summarized Comment';
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Summarized Comment field.';
                }

                field(Opinions; Rec.Opinions)
                {
                    Caption = 'Legal Opinion';
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Legal Opinion field.';
                }
            }
            group("Case Details")
            {
                Caption = 'Case Details';
                field(Comments; Rec.Comments)
                {
                    Caption = 'Case Details';
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Case Details field.';
                }

                field(Attendance; Rec.Attendance)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Attendance field.';
                }
                field("Hearing Date"; Rec."Hearing Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Hearing Date field.';
                }
            }

            group(Litigation)
            {
                Caption = 'Litigation';
                field(CaseDetails; Rec."Case Details")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Case Details field.';
                }
                field(LitigationCleared; Rec."Litigation Cleared")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Litigation Cleared field.';
                }
                group(CourtProcedings)
                {
                    Caption = 'Court Procedings';
                }
                field(ProceedingsDate; Rec."Proceedings Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Proceedings Date field.';
                }
                field(CourtNegotiations; Rec."Court Negotiations")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Court Negotiations field.';
                }
                field(CourtSettlementDetails; Rec."Court Settlement Details")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Court Settlement Details field.';
                }
                field(SettlementOutofCourt; Rec."Settlement Out of Court")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Settlement Out of Court field.';
                }
                field(NextCourtSchedule; Rec."Next Court Schedule")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Next Court Schedule field.';
                }
                field("Next Hearing Date"; Rec."Next Hearing Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Next Hearing Date field.';
                }
                field(SettlementDate; Rec."Settlement Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Settlement Date field.';
                }
                field("Progress Status"; Rec."Progress Status")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Progress Status field.';
                }
            }
        }
        area(factboxes)
        {


            part("Attached Documents"; "Document Attachments")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = CONST(70134739),
                              "No." = FIELD("No");
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = Notes;
            }
        }
    }

    actions
    {
        area(creation)
        {
            action(admin)
            {
                ApplicationArea = Basic;
                Caption = 'Admit';
                Image = AddContacts;
                Promoted = true;
                PromotedIsBig = true;
                Visible = false;
                ToolTip = 'Executes the Admit action.';

                trigger OnAction()
                begin
                    Rec.TestField("Visitor Name");
                    Rec.TestField("ID Number");
                    Rec.TestField("Phone Number");
                    Rec.TestField("Person To See");
                    Rec.TestField("Purpose of Visit");
                    Rec.TestField(Department);
                    Rec.TestField("Visitor Pass No.");

                    if Confirm('Mark visitor as admitted?', true) = false then Error('Cancelled by user: ' + UserId);

                    Rec."Initiated By" := UserId;
                    Rec."Initiated By Time" := Time;
                    Rec."Initiated Date" := Today;
                    //  Status := Status::Entered;
                    Rec.Modify;
                    Message('Admitted!');
                end;
            }
            action(Approvals)
            {
                ApplicationArea = Basic;
                Caption = 'Approvals';
                Image = Approvals;
                Promoted = true;
                PromotedCategory = Category9;
                ToolTip = 'Executes the Approvals action.';

                trigger OnAction()
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    /*DocumentType:=DocumentType::Requisition;
                    ApprovalEntries.SetRecordFilters(DATABASE::"Store Requistion Header",DocumentType,"No.");
                    ApprovalEntries.RUN;
                    */
                    ApprovalsMgmt.OpenApprovalEntriesPage(Rec.RecordId);

                end;
            }
            action(sendApproval)
            {
                ApplicationArea = Basic;
                Caption = 'Send A&pproval Request';
                Image = SendApprovalRequest;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                ToolTip = 'Executes the Send A&pproval Request action.';

                trigger OnAction()
                var
                    State: Option Open,"Pending Approval",Cancelled,Approved;
                begin

                    /*
                    IF NOT LinesExists THEN
                       ERROR('There are no Lines created for this Document');
                    */
                    State := State::Open;
                    //  if Status <> Status::Released then State := State::Open;
                    Rec.TestField("Responsibility Center");
                    /* DocType:=DocType::Requisition;
                     CLEAR(tableNo);
                     tableNo:=DATABASE::"Store Requistion Header";
                     ApprovalMgt.SendApproval(tableNo,Rec."No.",DocType,State,'',"Responsibility Center");*/
                    //    ApprovalMgt.SendApproval(Table_id,Doc_No,Doc_Type,Status,WebUser)

                    VarVariant := Rec;
                    if CustomApprovals.CheckApprovalsWorkflowEnabled(VarVariant) then
                        CustomApprovals.OnSendDocForApproval(VarVariant);

                end;
            }
            action(cancellsApproval)
            {
                ApplicationArea = Basic;
                Caption = 'Cancel Approval Re&quest';
                Image = Cancel;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                ToolTip = 'Executes the Cancel Approval Re&quest action.';

                trigger OnAction()
                begin
                    /* DocType:=DocType::Requisition;
                     showmessage:=TRUE;
                     ManualCancel:=TRUE;
                     CLEAR(tableNo);
                     tableNo:=DATABASE::"Store Requistion Header";
                      IF ApprovalMgt.CancelApproval(tableNo,DocType,Rec."No.",showmessage,ManualCancel) THEN;*/

                    VarVariant := Rec;
                    CustomApprovals.OnCancelDocApprovalRequest(VarVariant);

                end;
            }
            separator(Action7) { }

            action("Litigation Ongoing")
            {
                ApplicationArea = Basic;
                Caption = 'Mark As Ongoing';
                Image = Agreement;
                ToolTip = 'Executes the Mark As Ongoing action.';

                trigger OnAction()
                begin

                    if Confirm('Are you sure you want to mark the case as ongoing?', false) = true then begin

                        Rec."Progress Status" := Rec."Progress Status"::Ongoing;
                        Rec.Status := Rec.Status::PendingApproval;
                        Rec.Modify;
                        // Message('The legal Matter has been closed');
                    end;
                end;
            }
            action("Litigation Cleared")
            {
                ApplicationArea = Basic;
                Caption = 'Mark As Closed';
                Image = Agreement;
                ToolTip = 'Executes the Mark As Closed action.';

                trigger OnAction()
                begin
                    if Rec."Court Settlement Details" = '' then
                        Error('Court Settlement Details Have to Be Filled!.');
                    if Confirm('Are you sure you want to proceed and close the record?', false) = true then begin

                        Rec."Settlement Date" := Today;

                        Rec."Issue Date" := Today;
                        Rec."Cleared By" := UserId;
                        Rec."Cleared By Time" := Time;

                        //"Litigation Status" := "litigation status"::Cleared;
                        Rec."Litigation Cleared" := true;
                        Rec."Progress Status" := Rec."Progress Status"::Closed;
                        // Status := Status::Cleared;
                        Rec.Modify;
                        Message('The legal Matter has been closed');
                    end;
                end;
            }
            separator(Action46) { }
            action("Settle Out Of Court")
            {
                ApplicationArea = Basic;
                Caption = 'Settle Out Of Court';
                Image = settle;
                ToolTip = 'Executes the Settle Out Of Court action.';

                trigger OnAction()
                begin
                    if Rec."Settlement Details" = '' then
                        Error('Out Of Court Settlement Details Have to Be Filled!.');
                    if Confirm('Are you sure you want to proceed and settle the matter out of court?', false) = true then
                        Rec."Send to Litigation" := true;
                    Rec."Settlement Date" := Today;
                    Rec."Settlement Out of Court" := true;
                    Rec."Issue Date" := Today;
                    Rec."Cleared By" := UserId;
                    Rec."Cleared By Time" := Time;

                    Rec."Litigation Status" := Rec."litigation status"::Approved;
                    Rec."Litigation Cleared" := true;
                    Rec.Modify;
                    Rec.Status := Rec.Status::Approved;
                    Rec."Progress Status" := Rec."Progress Status"::Closed;
                    Message('The legal Matter has been Settled Out of Court.');
                end;
            }
            action("Send To Litigation")
            {
                ApplicationArea = Basic;
                Caption = 'Send To Litigation';
                Visible = false;
                ToolTip = 'Executes the Send To Litigation action.';

                trigger OnAction()
                begin
                    if Confirm('Are you sure you want to submit for Litigation?', false) = true then
                        Rec."Send to Litigation" := true;

                    Rec."Issue Date" := Today;
                    Rec."Cleared By" := UserId;
                    Rec."Cleared By Time" := Time;
                    Message('The legal Matter has been Submitted For Litigation.');
                    //  "Litigation Status" := "litigation status"::Cleared;
                    Rec.Status := Rec.Status::Approved;
                    Rec."Litigation Cleared" := true;
                    Rec.Modify;
                end;
            }
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec."Send to Litigation" := true;
        Rec.Type := Rec.Type::Letigation;
        Rec.Status := Rec.Status::New;
    end;

    trigger OnInit()
    begin
        Rec."Created Date" := Today;
        Rec."Created Time" := Time;
        Rec."Initiated By" := UserId;
        Rec."Initiated By Time" := Time;

    end;

    trigger OnOpenPage()
    begin
        Rec."Created Date" := Today;
        Rec."Created Time" := Time;
        Rec."Initiated By" := UserId;
        Rec."Initiated By Time" := Time;
    end;

    var
        VarVariant: Variant;
        CustomApprovals: Codeunit "Custom Approvals Codeunit";
}

