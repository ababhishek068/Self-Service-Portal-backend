Page 51276 "Conference Card"
{
    PageType = Card;
    SourceTable = "Conference Attendance";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(ReqNo; Rec."Req No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Req No. field.';
                }
                field(ReqCategory; Rec."Req. Category")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Req. Category field.';
                }
                field(No; Rec."No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Name field.';
                }
                field(Phone; Rec.Phone)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Phone field.';
                }
                field(Email; Rec.Email)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Email field.';
                }
                field(IDNumber; Rec."I.D. Number")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the I.D. Number field.';
                }
                field(DateofPresentation; Rec."Date of Presentation")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date of Presentation field.';
                }
                field(DegreeProgram; Rec."Degree Program")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Degree Program field.';
                }
                field(PHDProgramme; Rec."P.H.D Programme")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the P.H.D Programme field.';
                }
                field(TitleofResearch; Rec."Title of Research")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Title of Research field.';
                }
                field(ProjectNo; Rec."Project No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Project No. field.';
                }
                field(ProjectName; Rec."Project Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Project Name field.';
                }
                field(TotalAmountRequested; Rec."Total Amount Requested")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Total Amount Requested field.';
                }
                field(FirstTimePresention; Rec."First Time Presention")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the First Time Presention field.';
                }
                field(ComfirmedAttachements; Rec."Comfirmed Attachements?")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Comfirmed Attachements? field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field(RequestedDate; Rec."Requested Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Requested Date field.';
                }
                field(RequestedBy; Rec."Requested By")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Requested By field.';
                }

            }


            group(Funding)
            {
                Caption = 'Funding';
                field(ReceivedConferenceFundingBefore; Rec."Conference Funding Before")
                {
                    ApplicationArea = Basic;
                    Caption = 'Received Conference Funding Before?';
                    ToolTip = 'Specifies the value of the Received Conference Funding Before? field.';
                }
                field(WhichSemesterYear; Rec."Semester/Year")
                {
                    ApplicationArea = Basic;
                    Caption = 'Which Semester/Year?';
                    ToolTip = 'Specifies the value of the Which Semester/Year? field.';
                }
            }
            group(Authors)
            {
                Caption = 'Authors';
                part(Author; "Conference Authors")
                {
                    ApplicationArea = basic;
                    SubPageLink = "No." = field("Req No.");
                }
            }
            group(ExpenseSummary)
            {
                Caption = 'Expense Summary';
                part(Expense; "Conference Lines")
                {
                    ApplicationArea = basic;
                    SubPageLink = "No." = field("Req No.");
                }
            }
        }
        area(factboxes)
        {

            part("Attached Documents"; "Document Attachments")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = CONST(51621),
                              "No." = FIELD("No.");
            }
            systempart(Control1905767507; Notes)
            {
                Caption = 'Notes';
                ApplicationArea = Notes;
            }

            systempart(Control11; MyNotes) { }
        }

    }

    actions
    {

        area(processing)
        {
            action("Confirm Documnts Attachment.")
            {
                ApplicationArea = Basic;
                Image = Add;
                Promoted = true;
                ToolTip = 'Executes the Confirm Documnts Attachment. action.';

                trigger OnAction()
                begin
                    if Confirm('Are You Sure all the Mandatory Documentation are Attached', false) = true then
                        Rec."Comfirmed Attachements?" := true;
                    Message('Documents Attached');
                end;
            }
            group(RequestApproval)
            {
                Caption = 'Request Approval';
                action(SendApprovalRequest)
                {
                    ApplicationArea = Basic;
                    Caption = 'Send A&pproval Request';
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Process;
                    ToolTip = 'Executes the Send A&pproval Request action.';

                    trigger OnAction()
                    // PayLines: Record UnknownRecord50708;
                    begin
                        if not Rec."Comfirmed Attachements?" then
                            Error('There are attachments missing for this Document');
                        VarVariant := Rec;
                        if CustomApprovals.CheckApprovalsWorkflowEnabled(VarVariant) then
                            CustomApprovals.OnSendDocForApproval(VarVariant);

                    end;
                }
                action(CancelApprovalRequest)
                {
                    ApplicationArea = Basic;
                    Caption = 'Cancel Approval Re&quest';
                    Enabled = true;
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = Process;
                    ToolTip = 'Executes the Cancel Approval Re&quest action.';

                    trigger OnAction()
                    begin
                        VarVariant := Rec;
                        CustomApprovals.OnCancelDocApprovalRequest(VarVariant);
                    end;
                }
            }
            group(Navigate)
            {
                Caption = 'Navigate';
                action(Approvals)
                {
                    ApplicationArea = Basic;
                    Caption = 'Approvals';
                    Image = Approvals;
                    Promoted = true;
                    PromotedCategory = Process;
                    ToolTip = 'Executes the Approvals action.';

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin

                        ApprovalsMgmt.OpenApprovalEntriesPage(Rec.RecordId);
                    end;
                }
            }
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec."Requested By" := UserId;
        Rec."Requested Date" := Today;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Requested By" := UserId;
        Rec."Requested Date" := Today;
    end;

    var
        VarVariant: Variant;
        CustomApprovals: Codeunit "Custom Approvals Codeunit";
}

