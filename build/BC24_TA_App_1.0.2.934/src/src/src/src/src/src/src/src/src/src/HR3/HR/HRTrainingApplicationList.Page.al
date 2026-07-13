page 50751 "HR Training Application List"
{
    CardPageID = "HR Training Application Card";
    Editable = false;
    PageType = List;
    SourceTable = "HR Training Applications";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field("Application No"; Rec."Application No")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Application No field.';
                }
                field("Training Category"; Rec."Training Category")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Training Category field.';
                }
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the User ID field.';
                }
                field("Course Title"; Rec."Course Title")
                {
                    Style = StrongAccent;
                    StyleExpr = TRUE;
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Course Title field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field("Purpose of Training"; Rec."Purpose of Training")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Purpose of Training field.';
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
                field("Cost Of Training"; Rec."Cost Of Training")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Cost Of Training field.';
                }
                field(Provider; Rec."Training Institution")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Training Institution field.';
                }
                field(Status; Rec.Status)
                {
                    Style = Strong;
                    StyleExpr = TRUE;
                    ToolTip = 'Specifies the value of the Status field.';
                }
            }
        }
        area(factboxes)
        {
            // part(Control1102755002; "Job_Salary grade/steps1")
            // {
            //     ApplicationArea = basic;
            //     SubPageLink = Grade = FIELD("Application No");
            // }
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
                    ToolTip = 'Executes the Comments action.';

                    trigger OnAction()
                    var
                        DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,Receipt,"Staff Claim","Staff Advance",AdvanceSurrender,"Bank Slip",Grant,"Grant Surrender","Employee Requisition","Leave Application","Training Application","Transport Requisition";
                    begin
                        DocumentType := DocumentType::"Training Application";

                        //ApprovalComments.SetRecordFilters(DATABASE::"HR Training Applications",DocumentType,"Application No");
                        //ApprovalComments.SetUpLine(DATABASE::"HR Training Applications",DocumentType,"Application No");
                        //ApprovalComments.RUN;
                    end;
                }
            }
            group("F&unctions")
            {
                Caption = 'F&unctions';
                action("Training Participants")
                {
                    Caption = 'Training Participants';
                    Image = PersonInCharge;
                    Promoted = true;
                    PromotedCategory = Category4;
                    RunObject = Page "HR Training Partcipants";
                    RunPageLink = "Training Code" = FIELD("Application No");
                    ToolTip = 'Executes the Training Participants action.';
                }
                action("Training Cost Elements")
                {
                    Caption = 'Training Cost Elements';
                    Image = CalculateCost;
                    Promoted = true;
                    PromotedCategory = Category4;
                    RunObject = Page "HR Training Cost";
                    RunPageLink = "Training Id" = FIELD("Application No");
                    ToolTip = 'Executes the Training Cost Elements action.';
                }
                action("&Approvals")
                {
                    Caption = '&Approvals';
                    Image = Approvals;
                    Promoted = true;
                    PromotedCategory = Category4;
                    ToolTip = 'Executes the &Approvals action.';

                    trigger OnAction()
                    var
                        DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,Receipt,"Staff Claim","Staff Advance",AdvanceSurrender,"Store Requisition","Employee Requisition","Leave Application","Transport Requisition","Training Requisition","Job Approval";
                        ApprovalEntries: Page "Approval Entries";
                    begin
                        DocumentType := DocumentType::"Training Requisition";
                        ApprovalEntries.SetRecordFilters(DATABASE::"HR Training Applications", DocumentType, Rec."Application No");
                        ApprovalEntries.Run;
                    end;
                }
                action("&Send Approval &Request")
                {
                    Caption = '&Send Approval &Request';
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category4;
                    ToolTip = 'Executes the &Send Approval &Request action.';

                    trigger OnAction()
                    begin
                        TESTFIELDS;
                        Rec.CalcFields("No of Participants");
                        if (Rec."No of Participants" < 2) then begin
                            Error('Participants should not be less than two');
                        end;
                        if (Rec."No of Participants" > Rec."No of Required Participants") then begin
                            Error('Nominated Participants cannot exceed the Number of Participants Required ');
                        end;
                        if (Rec."No of Participants" <= 0) then begin
                            Error('Nominated Participants cannot be Less Than or Equal to Zero');
                        end;

                        if Confirm('Send this Application for Approval?', true) = false then exit;
                        //ApprovalMgt.SendTrainingAppApprovalRequest(Rec);
                    end;
                }
                action("&Cancel Approval request")
                {
                    Caption = '&Cancel Approval request';
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = Category4;
                    ToolTip = 'Executes the &Cancel Approval request action.';

                    trigger OnAction()
                    begin
                        if Confirm('Are you sure you want to cancel the approval request', true) = false then exit;
                        //ApprovalMgt.CancelTrainingAppApprovalReq(Rec,TRUE,TRUE);
                    end;
                }
                action("&Print")
                {
                    Caption = '&Print';
                    ApplicationArea = Basic;
                    Image = Print;
                    ToolTip = 'Executes the &Print action.';
                    trigger OnAction()
                    var
                        HRTraining: Record "HR Training Applications";
                        TRReport: Report "Training List";
                    begin
                        HRTraining.Reset();
                        if HRTraining.Find('-') then begin
                            TRReport.SetTableView(HRTraining);
                            TRReport.Run();

                        end;
                    end;
                }
                action("<A ction1102755042>")
                {
                    Caption = 'Re-Open';
                    Image = ReOpen;
                    Promoted = true;
                    PromotedCategory = Category4;
                    Visible = false;
                    ToolTip = 'Executes the Re-Open action.';

                    trigger OnAction()
                    begin
                        Rec.Status := Rec.Status::New;
                        Rec.Modify;
                    end;
                }
            }
        }
    }

    procedure TESTFIELDS()
    begin
        Rec.TestField("Course Title");
        Rec.TestField("From Date");
        Rec.TestField("To Date");
        Rec.TestField("Duration Units");
        Rec.TestField(Duration);
        Rec.TestField("Cost Of Training");
        Rec.TestField(Location);
        Rec.TestField(Trainer);
        Rec.TestField("Purpose of Training");
        Rec.TestField(Description)
    end;

    procedure UpdateControls()
    begin

        /*IF "Training category"="Training category"::Group THEN BEGIN
        CurrPage.Description.EDITABLE:=TRUE;
        END ELSE BEGIN
        CurrPage.Description.EDITABLE:=FALSE;
        END;
   */

    end;
}

