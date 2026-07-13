Page 50289 "HR Disciplinary Cases List"
{
    Caption = 'Employee Disciplinary Cases ';
    CardPageID = "HR Disciplinary Case Card";
    Editable = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Reports,Functions,Case Status,Show';
    SourceTable = "HR Disciplinary Cases";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(CaseNumber; Rec."Case Number")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Case Number field.';
                }
                field(DateofComplaint; Rec."Date of Complaint")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date of Complaint field.';
                }
                field(TypeComplaint; Rec."Type of Complaint")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Type of Complaint field.';
                }
                field("Complaint Description"; Rec."Complaint Description")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Complaint Description field.';
                }
                field(Accuser; Rec.Accuser)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Accuser field.';
                }
                field(AccusedEmployee; Rec."Accused Employee")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Accused Employee field.';
                }
                field("More Information"; Rec."More Information")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the More Information field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field(DisciplinaryStageStatus; Rec."Disciplinary Stage Status")
                {
                    ApplicationArea = Basic;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Disciplinary Stage Status field.';
                }
            }
        }
        area(factboxes)
        {
            part(Control1102755006; "HR Disciplinary Cases Factbox")
            {
                Caption = 'HR Disciplinary Cases Factbox';
                SubPageLink = "Case Number" = field("Case Number");
            }
            systempart(Control1102755009; Outlook) { }
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

                        /*
                        IF "Disciplinary Stage Status" ="Disciplinary Stage Status"::"Under Investigation" THEN EXIT;
                        IF "Disciplinary Stage Status" ="Disciplinary Stage Status"::"In Progress" THEN EXIT;
                        IF "Disciplinary Stage Status" ="Disciplinary Stage Status"::Closed THEN EXIT;
                        IF "Disciplinary Stage Status" ="Disciplinary Stage Status"::"Under Review" THEN EXIT;
                        */

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

                        /*
                        IF "Disciplinary Stage Status" ="Disciplinary Stage Status"::"Under Investigation" THEN EXIT;
                        IF "Disciplinary Stage Status" ="Disciplinary Stage Status"::"In Progress" THEN EXIT;
                        IF "Disciplinary Stage Status" ="Disciplinary Stage Status"::Closed THEN EXIT;
                        IF "Disciplinary Stage Status" ="Disciplinary Stage Status"::"Under Review" THEN EXIT;
                        */

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

                        /*
                        IF "Disciplinary Stage Status" ="Disciplinary Stage Status"::"Under Investigation" THEN EXIT;
                        IF "Disciplinary Stage Status" ="Disciplinary Stage Status"::"In Progress" THEN EXIT;
                      //  IF "Disciplinary Stage Status" ="Disciplinary Stage Status"::Closed THEN EXIT;
                        IF "Disciplinary Stage Status" ="Disciplinary Stage Status"::"Under Review" THEN EXIT;
                        */

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


                        if Confirm('Are you sure you want to mark this case as "Under Review?"') then begin
                            Rec."Disciplinary Stage Status" := Rec."disciplinary stage status"::"Under review";
                            Rec.Modify;
                            Message('Case Number %1 has been marked as "Under Review"', Rec."Case Number");
                        end;
                    end;
                }
                action(Print)
                {
                    ApplicationArea = Basic;
                    Caption = 'Print Cases List';
                    Ellipsis = true;
                    Image = Print;
                    ToolTip = 'Executes the Print Cases List action.';
                    trigger OnAction()
                    var
                        HRDispcase: Record "HR Disciplinary Cases";
                        DispCases: Report "Displinary Cases List";
                    begin
                        HRDispcase.Reset();
                        if HRDispcase.Find('-') then begin
                            DispCases.SetTableView(HRDispcase);
                            DispCases.Run();
                        end;
                    end;
                }
            }
        }
    }
}

