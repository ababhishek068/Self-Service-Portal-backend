page 50245 "Contract Renewals"
{
    Caption = 'Contract Amendments/Extensions';
    PageType = List;
    SourceTable = "Contract Renewals";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Contract Reference No"; Rec."Contract Reference No")
                {
                    ToolTip = 'Specifies the value of the Contract Reference No field.';
                }
                field("Contract Type"; Rec."Contract Type")
                {
                    ToolTip = 'Specifies the value of the Contract Type field.';
                }
                field("Contractor No."; Rec."Contractor No.")
                {
                    ToolTip = 'Specifies the value of the Contractor No. field.';
                }
                field("Contractor Name"; Rec."Contractor Name")
                {
                    ToolTip = 'Specifies the value of the Contractor Name field.';
                }
                field("Effective Date(Original)"; Rec."Effective Date(Original)")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Effective Date(Original) field.';
                }
                field("Expiry Date(Original)"; Rec."Expiry Date(Original)")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Expiry Date(Original) field.';
                }
                field("Effective Date"; Rec."Effective Date")
                {
                    ToolTip = 'Specifies the value of the Effective Date field.';
                }
                field(Duration; Rec.Duration)
                {
                    ToolTip = 'Specifies the value of the Duration field.';
                }
                field("Expiry Date"; Rec."Expiry Date")
                {
                    ToolTip = 'Specifies the value of the Expiry Date field.';
                }
                field("Contract Value(Original)"; Rec."Contract Value(Original)")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Contract Value(Original) field.';
                }
                field("Contract Value"; Rec."Contract Value")
                {
                    ToolTip = 'Specifies the value of the Contract Value field.';
                }
                field(Posted; Rec.Posted)
                {
                    ToolTip = 'Specifies the value of the Posted field.';
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    ToolTip = 'Specifies the value of the Approval Status field.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Post Extension")
            {
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the Post Extension action.';

                trigger OnAction()
                begin
                    IF CONFIRM('Are you sure you want to post this extension?', FALSE) THEN BEGIN
                        Rec.TESTFIELD("Approval Status", Rec."Approval Status"::Approved);
                        Rec.TESTFIELD("Effective Date");
                        Rec.TESTFIELD(Posted, FALSE);
                        Contracts.RESET;
                        IF Contracts.GET(Rec."Contract Reference No") THEN
                            Rec."Effective Date(Original)" := Contracts."Effective Date";
                        Rec."Contract Value(Original)" := Contracts."Contract Value";
                        Rec."Expiry Date(Original)" := Contracts."Expiry Date";
                        Rec.Posted := TRUE;
                        Rec."Posted By" := USERID;
                        Rec."Posted On" := TODAY;
                        Rec.MODIFY;
                        //update contracts with new values
                        Contracts.Status := Contracts.Status::Extended;
                        Contracts."Effective Date" := Rec."Effective Date";
                        Contracts."Contract Value" := Rec."Contract Value";
                        Contracts."Expiry Date" := Rec."Expiry Date";
                        Contracts.Duration := Rec.Duration;
                        Contracts.MODIFY;
                        CurrPage.UPDATE;
                        MESSAGE('Contract Successfully Extended');
                    END ELSE BEGIN
                        ERROR('Process aborted');
                    END;
                end;
            }
            action("Send A&pproval Request")
            {
                Caption = 'Send A&pproval Request';
                Image = SendApprovalRequest;
                Promoted = true;
                PromotedCategory = Category4;
                ToolTip = 'Executes the Send A&pproval Request action.';

                trigger OnAction()
                begin
                    IF NOT Rec.HASLINKS THEN
                        ERROR('Please attach documents on the links page');

                    VarVariant := Rec;
                    IF ApprovalsMgmt.CheckApprovalsWorkflowEnabled(VarVariant) THEN
                        ApprovalsMgmt.OnSendDocForApproval(VarVariant);
                end;
            }
            action(Approvals)
            {
                Caption = 'Approvals';
                Image = Approvals;
                Promoted = true;
                PromotedCategory = Category4;
                ToolTip = 'Executes the Approvals action.';

                trigger OnAction()
                begin

                    //ApprovalsMgmt.OpenApprovalEntriesPage(RECORDID)
                end;
            }
            action("Cancel Approval Re&quest")
            {
                Caption = 'Cancel Approval Re&quest';
                Image = CancelApprovalRequest;
                Promoted = true;
                PromotedCategory = Category4;
                ToolTip = 'Executes the Cancel Approval Re&quest action.';

                trigger OnAction()
                begin

                    VarVariant := Rec;
                    ApprovalsMgmt.OnCancelDocApprovalRequest(VarVariant);
                end;
            }
        }
    }

    var
        VarVariant: Variant;
        ApprovalsMgmt: Codeunit "Custom Approvals Codeunit";
        Contracts: Record Contract;
}

