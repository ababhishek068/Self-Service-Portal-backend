page 51442 "Tender Committee"
{
    PageType = List;
    SourceTable = "Tender Committee";
    Caption = 'Procurement Committee';
    ApplicationArea = All;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Tendor No"; Rec."Tendor No")
                {
                    Caption = 'No';
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the No field.';
                }
                field("Tender Description"; Rec."Tender Description")
                {
                    caption = 'Description';
                    ApplicationArea = basic;
                    Visible=false;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(User; Rec.User)
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the User field.';
                }
                field("Employee Name";"Employee Name"){}
                field(UserPassword; Rec.UserPassword)
                {
                    ExtendedDatatype = Masked;
                    HideValue = true;
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the UserPassword field.';
                }
                field(Designation; Rec.Designation)
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Designation field.';
                }
                field("Committee Type"; Rec."Committee Type")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Committee Type field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Status field.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Close)
            {
                Caption = 'Close';
                Image = Close;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the Close action.';

                trigger OnAction()
                var
                    ObjTCommit: Record "Tender Committee";
                begin
                    if Confirm('Are you sure you want to close ' + Format(Rec."Committee Type")) = true then begin
                        ObjTCommit.Reset();
                        ObjTCommit.SetRange("Tendor No", Rec."Tendor No");
                        ObjTCommit.SetRange("Committee Type", Rec."Committee Type");
                        if ObjTCommit.Find('-') then begin
                            repeat
                                ObjTCommit.Closed := true;
                                ObjTCommit.Modify();
                            until ObjTCommit.Next = 0;
                            Message('Success');
                            CurrPage.Close();
                        end;
                    end else
                        Error('Process Aborted');

                end;
            }
            action(Approvals)
            {
                Caption = 'Approvals';
                Image = Approvals;
                Promoted = true;
                ApplicationArea = all;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the Approvals action.';
                trigger OnAction()
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    RecID: RecordID;
                    FromRecRef: RecordRef;
                    DocDetails: Record "Tender Committee";
                begin
                    DocDetails.Reset();
                    DocDetails.SetRange("Tendor No", Rec."Tendor No");
                    if DocDetails.Find('-') then begin
                        FromRecRef.GETTABLE(DocDetails);
                        RecID := FromRecRef.RecordId;
                        ApprovalsMgmt.OpenApprovalEntriesPage(RecID);
                    end;
                end;
            }
            action(sendApproval)
            {
                Caption = 'Send A&pproval Request';
                Image = SendApprovalRequest;
                Promoted = true;
                ApplicationArea = all;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the Send A&pproval Request action.';
                trigger OnAction()
                var
                    VarVariant: Variant;
                    CustomApprovals: Codeunit "Custom Approvals Codeunit";
                begin

                    VarVariant := Rec;
                    if CustomApprovals.CheckApprovalsWorkflowEnabled(VarVariant) then
                        CustomApprovals.OnSendDocForApproval(VarVariant);

                end;
            }
            action(cancellsApproval)
            {
                Caption = 'Cancel Approval Re&quest';
                Image = Cancel;
                Promoted = true;
                ApplicationArea = all;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the Cancel Approval Re&quest action.';
                trigger OnAction()
                var
                    VarVariant: Variant;
                    CustomApprovals: Codeunit "Custom Approvals Codeunit";
                begin
                    VarVariant := Rec;
                    CustomApprovals.OnCancelDocApprovalRequest(VarVariant);
                end;
            }
        }
    }
}

