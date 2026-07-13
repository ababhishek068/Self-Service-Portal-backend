page 51005 "HR Training Evaluation Form"
{
    Caption = 'Back to Office Card';
    PageType = Card;
    SourceTable = "HRBack To Office Form";
    PromotedActionCategories = 'New,Process,Reports,Approval';
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Document No"; Rec."Document No")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Document No field.';
                }
                field("Course Title"; Rec."Course Title")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Course Title field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field("From Date"; Rec."From Date")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the From Date field.';
                }
                field("To Date"; Rec."To Date")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the To Date field.';
                }
                field(Location; Rec.Location)
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Location field.';
                }
                field(Trainer; Rec.Trainer)
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Trainer field.';
                }
                field("Training Institution"; Rec."Training Institution")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Training Institution field.';
                }
                field("Purpose of Training"; Rec."Purpose of Training")
                {
                    Caption = 'Justification';
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Justification field.';
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Employee No. field.';
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Employee Name field.';
                }
                field(Campus; Rec.Campus)
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Campus field.';
                }
                field(Department; Rec.Department)
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Department field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field("Training Objective"; Rec."Training Objective")
                {
                    ApplicationArea = basic;
                    MultiLine = true;
                    ToolTip = 'Specifies the value of the Training Objective field.';
                }
                field("Course Content"; Rec."Course Content")
                {
                    MultiLine = true;
                    ToolTip = 'Specifies the value of the Course Content field.';
                }
                field("Text 1"; Rec."Text 1")
                {
                    Caption = '1.Please state how the course has benefited you and the organization';
                    MultiLine = true;
                    ToolTip = 'Specifies the value of the 1.Please state how the course has benefited you and the organization field.';
                }
                field("Text 2"; Rec."Text 2")
                {
                    Caption = '2.Which specific areas do you think need improvement in your area of operation?';
                    MultiLine = true;
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the 2.Which specific areas do you think need improvement in your area of operation? field.';
                }

                field("Text 3"; Rec."Text 3")
                {
                    Caption = '3.How will you use the skills acquired to address the problem?';
                    MultiLine = true;
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the 3.How will you use the skills acquired to address the problem? field.';
                }
                field("Text 4"; Rec."Text 4")
                {
                    Caption = '4.Provide timeline within which you will cascade the skills learned to others in your Department/organization';
                    MultiLine = true;
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the 4.Provide timeline within which you will cascade the skills learned to others in your Department/organization field.';
                }

            }
        }
        area(factboxes)
        {


            part("Attached Documents"; "Document Attachments")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = CONST(70135108),
                              "No." = FIELD("Document No");
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = Notes;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Show")
            {
                Caption = '&Show';
                action(Comments)
                {
                    Caption = 'Comments';
                    Image = Comment;
                    Promoted = true;
                    PromotedCategory = Category5;
                    ApplicationArea = basic;
                    ToolTip = 'Executes the Comments action.';
                    trigger OnAction()
                    begin
                        /*
                        DocumentType:=DocumentType::"Training Application";
                        
                        ApprovalComments.SetRecordFilters(DATABASE::"HR Training Applications",DocumentType,"Application No");
                        ApprovalComments.SetUpLine(DATABASE::"HR Training Applications",DocumentType,"Application No");
                        ApprovalComments.RUN;
                        */

                    end;
                }
            }
            group("F&unctions")
            {
                Caption = 'F&unctions';
                action("&Approvals")
                {
                    Caption = '&Approvals';
                    Image = Approvals;
                    Promoted = true;
                    PromotedCategory = Category4;
                    ApplicationArea = basic;
                    ToolTip = 'Executes the &Approvals action.';
                    trigger OnAction()
                    var
                        DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,Receipt,"Staff Claim","Staff Advance",AdvanceSurrender,"Store Requisition","Employee Requisition","Leave Application","Transport Requisition","Training Requisition","Job Approval","Induction Approval","Disciplinary Approvals","Activity Approval","Exit Approval","Medical Claim Approval",Jv,BackToOffice;
                        ApprovalEntries: Page "Approval Entries";
                    begin

                        DocumentType := DocumentType::BackToOffice;
                        //ApprovalEntries.SetRecordFilters(DATABASE::"HRBack To Office Form",DocumentType,"Document No");
                        ApprovalEntries.Run;
                    end;
                }
                action("&Send Approval &Request")
                {
                    Caption = '&Send Approval &Request';
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category4;
                    ApplicationArea = basic;
                    ToolTip = 'Executes the &Send Approval &Request action.';
                    trigger OnAction()
                    begin

                        if Confirm('Send this Application for Approval?', true) = false then exit;
                        //     Var
                        //        ApprovalMgt.OnSendDocForApproval(Rec);
                    end;
                }
                action("&Cancel Approval request")
                {
                    Caption = '&Cancel Approval request';
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = Category4;
                    ApplicationArea = basic;
                    ToolTip = 'Executes the &Cancel Approval request action.';
                    trigger OnAction()
                    begin

                        if Confirm('Are you sure you want to cancel the approval request', true) = false then exit;
                        //ApprovalMgt.CancelBackOfficeAppApprovalReq(Rec,TRUE,TRUE);
                    end;
                }
                action("&Print")
                {
                    Caption = '&Print';
                    ApplicationArea = Basic;
                    Image = Print;
                    Promoted = true;
                    ToolTip = 'Executes the &Print action.';
                    trigger OnAction()
                    var
                        BackToOffice: Record "HRBack To Office Form";
                        BackOffice: Report "Back to Office Report";
                    begin
                        BackToOffice.Reset();
                        if BackToOffice.Find('-') then begin
                            BackOffice.SetTableView(BackToOffice);
                            BackOffice.Run();
                        end;
                    end;
                }
                separator(Separator1) { }
                action(Post)
                {
                    Caption = 'Mark as Back to Office';
                    Image = Undo;
                    ApplicationArea = basic;
                    ToolTip = 'Executes the Mark as Back to Office action.';
                    trigger OnAction()
                    begin
                        if Confirm('Do you really want to mark the employee as back to office?') then begin
                            HREmp.Get(Rec."Employee No.");
                            HREmp."On Leave" := false;
                            HREmp.Modify;
                        end;
                    end;
                }
            }
        }
    }

    var
        //ApprovalMgt: Codeunit "Approvals Management";
        HREmp: Record "HR-Employee";
}

