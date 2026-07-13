Page 50406 "HR Disciplinary Case Card"
{
    PageType = Card;
    PromotedActionCategories = 'New,Process,Reports,Functions,Case Status,Show';
    SourceTable = "HR Disciplinary Cases";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(CaseNumber; Rec."Case Number")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Case Number field.';
                }
                field(UserID; Rec."User ID")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the User ID field.';
                }
                field(DateofComplaint; Rec."Date of Complaint")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Date of Complaint field.';
                }
                field(AccusedEmployee; Rec."Accused Employee")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Accused Employee field.';
                }
                field(AccusedEmployeeName; Rec."Accused Employee Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Accused Employee Name field.';
                }
                field(TypeComplaint; Rec."Type of Complaint")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Type of Complaint field.';
                }
                field("Complaint Description"; Rec."Complaint Description")
                {
                    ApplicationArea = Basic;
                    Enabled = false;
                    ToolTip = 'Specifies the value of the Complaint Description field.';
                }
                field("More Information"; Rec."More Information")
                {
                    ApplicationArea = Basic;
                    MultiLine = true;
                    ToolTip = 'Specifies the value of the More Information field.';
                }
                field(SeverityOftheComplain; Rec."Severity Of the Complain")
                {
                    ApplicationArea = Basic;
                    Enabled = false;
                    ToolTip = 'Specifies the value of the Severity Of the Complain field.';
                }
                field(DateofComplaintwasReported; Rec."Date of Complaint was Reported")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date of Complaint was Reported field.';
                }
                field(AccussedBy; Rec."Accussed By")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Accussed By field.';
                }
                field(Accuser; Rec.Accuser)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Accuser field.';
                }
                field(AccuserName; Rec."Accuser Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Accuser Name field.';
                }
                field(NonEmployeeName; Rec."Non Employee Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Non Employee Name field.';
                }
                field(Witness1; Rec."Witness #1")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Witness #1 field.';
                }
                field(Witness1Name; Rec."Witness #1 Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Witness #1 Name field.';
                }
                field(Witness2; Rec."Witness #2")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Witness #2 field.';
                }
                field(Witness2Name; Rec."Witness #2  Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Witness #2  Name field.';
                }
                field(DateToDiscussCase; Rec."Date To Discuss Case")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date To Discuss Case field.';
                }
                field(BodyHandlingTheComplaint; Rec."Body Handling The Complaint")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Body Handling The Complaint field.';
                }
                field(ModeofLodgingtheComplaint; Rec."Mode of Lodging the Complaint")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Mode of Lodging the Complaint field.';
                }
                field(PolicyGuidlinesInEffect; Rec."Policy Guidlines In Effect")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Policy Guidlines In Effect field.';
                }
                field("Guid. In Effect Description"; Rec."Guid. In Effect Description")
                {
                    Caption = 'Policy Description';
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Policy Description field.';
                }
                field(ResponsibilityCenter; Rec."Responsibility Center")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Responsibility Center field.';
                }
                field(RecommendedAction; Rec."Recommended Action")
                {
                    ApplicationArea = Basic;
                    Editable = RecommendedActionEditable;
                    ToolTip = 'Specifies the value of the Recommended Action field.';
                }
                field(DisciplinaryStageStatus; Rec."Disciplinary Stage Status")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Disciplinary Stage Status field.';
                }
                field(Appealed; Rec.Appealed)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Appealed field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Status field.';
                }
            }
            group(ActionInformation)
            {
                Caption = 'Action Information';
                field(ActionTaken; Rec."Action Taken")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                    ToolTip = 'Specifies the value of the Action Taken field.';
                }
                field("Action Taken Description"; Rec."Action Taken Description")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Action Taken Description field.';
                }
                field(DisciplinaryRemarks; Rec."Disciplinary Remarks")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                    MultiLine = true;
                    ToolTip = 'Specifies the value of the Disciplinary Remarks field.';
                }
                field("Investigation Findings"; Rec.Comments)
                {
                    ApplicationArea = Basic;
                    MultiLine = true;
                    ToolTip = 'Specifies the value of the Comments field.';
                }
            }
        }
        area(factboxes)
        {
            part(Control1102755038; "HR Disciplinary Cases Factbox")
            {
                Caption = 'HR Disciplinary Cases Factbox';
                SubPageLink = "Case Number" = field("Case Number");
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Functions)
            {
                Caption = 'Functions';
                action(SendCaseApprovalRequest)
                {
                    ApplicationArea = Basic;
                    Caption = 'Send Case Approval Request';
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ToolTip = 'Executes the Send Case Approval Request action.';

                    trigger OnAction()
                    begin
                        if Confirm('Send this Case for Approval ?', true) = false then exit;
                        //AppMgmt.SendDisciplinaryApprovalReq(Rec);
                    end;
                }
                action(CancelCaseApprovalRequest)
                {
                    ApplicationArea = Basic;
                    Caption = 'Cancel Case Approval Request';
                    Image = CancelAllLines;
                    Promoted = true;
                    PromotedCategory = Category4;
                    ToolTip = 'Executes the Cancel Case Approval Request action.';

                    trigger OnAction()
                    begin
                        if Confirm('Cancel Case Approval Request?', true) = false then exit;
                        //AppMgmt.CancelDiscipplinaryAppApprovalReq(Rec,TRUE,TRUE);
                    end;
                }
                action(Approvals)
                {
                    ApplicationArea = Basic;
                    Caption = 'Approvals';
                    Image = Approvals;
                    Promoted = true;
                    PromotedCategory = Category4;
                    ToolTip = 'Executes the Approvals action.';

                    trigger OnAction()
                    var
                        DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,Receipt,"Staff Claim","Staff Advance",AdvanceSurrender,"Store Requisition","Employee Requisition","Leave Application","Transport Requisition","Training Requisition","Job Approval","Disciplinary Approvals";
                        ApprovalEntries: Page "Approval Entries";
                    begin
                        DocumentType := Documenttype::"Disciplinary Approvals";
                        ApprovalEntries.SetRecordFilters(Database::"HR Disciplinary Cases", DocumentType, Rec."Case Number");
                        ApprovalEntries.Run;
                    end;
                }
            }
            group("Case Status")
            {
                action("Under Investigation")
                {
                    ApplicationArea = Basic;
                    Caption = 'Under Investigation';
                    Image = OpenWorksheet;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    ToolTip = 'Executes the Under Investigation action.';

                    trigger OnAction()
                    begin
                        Rec.TestField(Status, Rec.Status::Approved);
                        if Rec."Disciplinary Stage Status" = Rec."disciplinary stage status"::"Investigation " then exit;
                        if Rec."Disciplinary Stage Status" = Rec."disciplinary stage status"::Inprogress then exit;
                        if Rec."Disciplinary Stage Status" = Rec."disciplinary stage status"::Closed then exit;
                        // IF "Disciplinary Stage Status" ="Disciplinary Stage Status"::"Under review" THEN EXIT;


                        if Confirm('Are you sure you want to mark this case as "Under Investigation"?') then begin
                            Rec."Disciplinary Stage Status" := Rec."disciplinary stage status"::"Investigation ";
                            Rec.Modify;
                            Message('Case Number %1 has been marked as under "Investigation"', Rec."Case Number");
                        end;
                    end;
                }
                action("In Progress")
                {
                    ApplicationArea = Basic;
                    Caption = 'In Progress';
                    Image = CarryOutActionMessage;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    ToolTip = 'Executes the In Progress action.';

                    trigger OnAction()
                    begin
                        Rec.TestField(Status, Rec.Status::Approved);


                        //IF "Disciplinary Stage Status" ="Disciplinary Stage Status"::"Investigation " THEN EXIT;
                        if Rec."Disciplinary Stage Status" = Rec."disciplinary stage status"::Inprogress then exit;
                        if Rec."Disciplinary Stage Status" = Rec."disciplinary stage status"::Closed then exit;
                        if Rec."Disciplinary Stage Status" = Rec."disciplinary stage status"::"Under review" then exit;


                        if Confirm('Are you sure you want to open Investigations for these Case?') then begin
                            Rec."Disciplinary Stage Status" := Rec."disciplinary stage status"::Inprogress;
                            Rec.Modify;
                            Message('Case Number %1 has been marked as "In Progress"', Rec."Case Number");
                        end;
                    end;
                }
                action(Close)
                {
                    ApplicationArea = Basic;
                    Caption = ' Close';
                    Image = Closed;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    ToolTip = 'Executes the  Close action.';

                    trigger OnAction()
                    begin
                        Rec.TestField(Status, Rec.Status::Approved);


                        if Rec."Disciplinary Stage Status" = Rec."disciplinary stage status"::"Investigation " then exit;
                        // IF "Disciplinary Stage Status" ="Disciplinary Stage Status"::"InProgress" THEN EXIT;
                        //  IF "Disciplinary Stage Status" ="Disciplinary Stage Status"::Closed THEN EXIT;
                        if Rec."Disciplinary Stage Status" = Rec."disciplinary stage status"::"Under review" then exit;


                        if Confirm('Are you sure you want to mark this case as "Closed"?') then begin
                            Rec."Disciplinary Stage Status" := Rec."disciplinary stage status"::Closed;
                            Rec.Modify;
                            Message('Case Number %1 has been marked as "Closed"', Rec."Case Number");
                        end;
                    end;
                }
                action(Appeal)
                {
                    ApplicationArea = Basic;
                    Caption = ' Appeal';
                    Image = ReopenCancelled;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    ToolTip = 'Executes the  Appeal action.';

                    trigger OnAction()
                    begin
                        Rec.TestField(Status, Rec.Status::Approved);

                        if Rec.Appealed = true then begin
                            Error('A case can only be Appealed once');
                        end;

                        if Rec."Disciplinary Stage Status" = Rec."disciplinary stage status"::"Investigation " then exit;
                        if Rec."Disciplinary Stage Status" = Rec."disciplinary stage status"::Inprogress then exit;
                        if Rec."Disciplinary Stage Status" = Rec."disciplinary stage status"::"Under review" then exit;


                        if Confirm('Are you sure you want to mark this case as "Under Review?"') then begin
                            Rec."Disciplinary Stage Status" := Rec."disciplinary stage status"::"Under review";
                            Rec.Appealed := true;
                            Rec.Modify;
                            Message('Case Number %1 has been marked as "Under Review"', Rec."Case Number");
                        end;
                    end;
                }
                action(Print)
                {
                    ApplicationArea = Basic;
                    Caption = 'Print Case';
                    Ellipsis = true;
                    Image = Print;
                    ToolTip = 'Executes the Print Case action.';
                    trigger OnAction()
                    var
                        HRDispcase: Record "HR Disciplinary Cases";
                        DispCases: Report "Displinary Cases Report";
                    begin
                        HRDispcase.Reset();
                        if HRDispcase.Find('-') then begin
                            DispCases.SetTableView(HRDispcase);
                            DispCases.Run();
                        end;
                    end;
                }
                action(PrintSuspension)
                {
                    ApplicationArea = Basic;
                    Caption = 'Print Suspension Letter';
                    Ellipsis = true;
                    Image = Print;
                    ToolTip = 'Executes the Print Suspension Letter action.';
                    trigger OnAction()
                    var
                        HRDispcase: Record "HR-Employee";
                        DispCases: Report "HR Suspension Letter";
                    begin
                        HRDispcase.Reset();
                        HRDispcase.setfilter("No.", Rec."Accused Employee");
                        if HRDispcase.Find('-') then begin
                            DispCases.SetTableView(HRDispcase);
                            DispCases.Run();
                        end;
                    end;
                }
                action(PrintInterdiction)
                {
                    ApplicationArea = Basic;
                    Caption = 'Print Interdiction Letter';
                    Ellipsis = true;
                    Image = Print;
                    ToolTip = 'Executes the Print Interdiction Letter action.';
                    trigger OnAction()
                    var
                        HRDispcase: Record "HR-Employee";
                        DispCases: Report "HR Interdiction Letter";
                    begin
                        HRDispcase.Reset();
                        HRDispcase.setfilter("No.", Rec."Accused Employee");
                        if HRDispcase.Find('-') then begin
                            DispCases.SetTableView(HRDispcase);
                            DispCases.Run();
                        end;
                    end;
                }
                action(PrintShowCourse)
                {
                    ApplicationArea = Basic;
                    Caption = 'Print Show Course Letter';
                    Ellipsis = true;
                    Image = Print;
                    ToolTip = 'Executes the Print Show Course Letter action.';
                    trigger OnAction()
                    var
                        HRDispcase: Record "HR-Employee";
                        DispCases: Report "HR Show Course Letter";
                    begin
                        HRDispcase.Reset();
                        HRDispcase.setfilter("No.", Rec."Accused Employee");
                        if HRDispcase.Find('-') then begin
                            DispCases.SetTableView(HRDispcase);
                            DispCases.Run();
                        end;
                    end;
                }

            }
        }
    }

    trigger OnInit()
    begin
        RecommendedActionEditable := true;
        ActionTakenEditable := true;
        DisciplinaryRemarksEditable := true;
    end;

    trigger OnOpenPage()
    begin
        UpdateControls;
    end;

    var
        RecommendedActionEditable: Boolean;
        ActionTakenEditable: Boolean;
        DisciplinaryRemarksEditable: Boolean;

    procedure UpdateControls()
    begin
        if Rec.Status = Rec.Status::New then begin
            RecommendedActionEditable := false;
            ActionTakenEditable := false;
            DisciplinaryRemarksEditable := false;
        end;

        if Rec.Status = Rec.Status::Approved then begin
            CurrPage.Editable := false;
        end;

        if Rec.Status = Rec.Status::"Pending Approval" then begin
            CurrPage.Editable := false;
        end;
    end;
}

