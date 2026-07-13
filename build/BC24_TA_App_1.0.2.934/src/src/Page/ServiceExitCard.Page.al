page 50434 "Service Exit Card"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Documents;
    SourceTable = "Service Exit";
    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field(No; Rec.No)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No field.';

                }
                field("Serial No"; Rec."Service No")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Service No field.';

                }
                field(Names; Rec.Names)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Names field.';

                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = All;
                    Caption = 'Document Date';
                    ToolTip = 'Specifies the value of the Document Date field.';
                }
                field("Date of Discharge"; Rec."Date of Discharge")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Date of Discharge field.';
                }
                field("Discharge Reason"; Rec."Discharge Reason")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Discharge Reason field.';

                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Remarks field.';

                }
                field("Course Undertaken"; Rec."Course Undertaken")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Course Undertaken field.';

                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Status field.';
                }
            }
        }
        area(Factboxes) { }
    }

    actions
    {
        area(Processing)
        {
            group("Approval Request")
            {
                Caption = 'Approval Request';
                action(SendApprovalRequest)
                {
                    Caption = 'Send Approval Request';
                    Image = SendApprovalRequest;
                    Promoted = true;
                    ApplicationArea = All;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ToolTip = 'Executes the Send Approval Request action.';

                    trigger OnAction();
                    var
                        VarVariant: Variant;
                        ApprovalsMgmt: Codeunit "Custom Approvals CU";
                    begin
                        Rec.TestField(Status, Rec.Status::New);


                        VarVariant := Rec;
                        IF ApprovalsMgmt.CheckApprovalsWorkflowEnabled(VarVariant) THEN
                            ApprovalsMgmt.RunWorkflowOnSendApprovalRequest(VarVariant);
                    end;
                }
                action("Cancel Approval Request")
                {
                    Caption = 'Cancel Approval Request';
                    Image = CancelApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ApplicationArea = All;
                    ToolTip = 'Executes the Cancel Approval Request action.';

                    trigger OnAction();
                    var
                        VarVariant: Variant;
                        ApprovalsMgmt: Codeunit "Custom Approvals CU";
                    begin

                        VarVariant := Rec; //Added
                        ApprovalsMgmt.OnCancelDocApprovalRequest(VarVariant);
                    end;
                }

                action(Approvals)
                {
                    Caption = 'Approvals';
                    Image = Approvals;
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedCategory = Category4;
                    ToolTip = 'Executes the Approvals action.';

                    trigger OnAction();
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.OpenApprovalEntriesPage(Rec.RECORDID)
                    end;
                }

            }


            action(ActionName)
            {
                ApplicationArea = All;
                Caption = 'Post Discharge';
                Image = PostedPutAway;
                ToolTip = 'Executes the Post Discharge action.';
                trigger OnAction();
                var
                    RegForm: Record "Registration Form";
                begin
                    Rec.TestField(Posted, false);
                    Rec.TestField("Discharge Reason");


                    if Confirm('Do you really want to post the Discharge', false) then begin
                        if RegForm.get(Rec."Service No") then begin
                            RegForm.Status := RegForm.Status::Exited;
                            RegForm."Date of Exit" := Rec."Date of Discharge";
                            RegForm."Discharge Reason" := Rec."Discharge Reason";
                            RegForm."Exit Mode" := Rec."Discharge Reason";
                            RegForm.modify;
                        end;


                        Rec.Posted := true;
                        Rec."Posted By" := UserId;
                        Rec."Date Posted" := today;
                        Rec.modify;
                    end;
                end;
            }
        }
    }
}