Page 50387 "Approved Gate Pass Card"
{
    Editable = false;
    PageType = Card;
    SourceTable = "Gate Pass";
    SourceTableView = where(Status = const(Approved));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(Group)
            {
                field(GatePassNo; Rec."Gate Pass No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Gate Pass No. field.';
                }
                field(DateOut; Rec."Date Out")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date Out field.';
                }
                field(TimeOut; Rec."Time Out")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Time Out field.';
                }
                field(AssetTransferNo; Rec."Asset Transfer No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Asset Transfer No field.';
                }
                field(DateCreated; Rec."Date Created")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date Created field.';
                }
                field(AssetDescription; Rec."Asset Description")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Asset Description field.';
                }
                field(AssetFromLocation; Rec."Asset From Location")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Asset From Location field.';
                }
                field(AssetToLocation; Rec."Asset To Location")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Asset To Location field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Status field.';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control13; Outlook) { }
        }
    }

    actions
    {
        area(processing)
        {
            action(SendApprovalRequest)
            {
                ApplicationArea = Basic;
                Caption = 'Send Approval Request';
                Image = SendApprovalRequest;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = false;
                ToolTip = 'Executes the Send Approval Request action.';

                trigger OnAction()
                begin

                    if Confirm('Send this Asset Transfer for Approval?', true) = false then exit;
                    Rec.Status := Rec.Status::Approved

                    //ApprovalMgt.SendAssetTransApprovalReq(Rec);
                end;
            }
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
                    DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order",Jobs,"Employee Req",Employees,Promotion,Confirmation,"Employee Transfer","Asset Transfer","Transport Req",Overtime,"Training App","Leave App";
                begin

                    DocumentType := Documenttype::"Asset Transfer";
                    //ApprovalEntries.SetRecordFilters(DATABASE::"HR Asset Transfer Header",DocumentType,"No.");
                    //ApprovalEntries.RUN;
                end;
            }
            action(CancelApprovalRequest)
            {
                ApplicationArea = Basic;
                Caption = 'Cancel Approval Request';
                Image = Cancel;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = false;
                ToolTip = 'Executes the Cancel Approval Request action.';

                trigger OnAction()
                begin
                    if Confirm('Cancel Approval Request for this Asset Transfer?', true) = false then exit;
                    //Status:=Status::Cancelled


                    //ApprovalMgt.CancelAssetTransAppRequest(Rec,TRUE,TRUE);
                end;
            }
            action("Conformation Of Work")
            {
                ApplicationArea = Basic;
                RunObject = Page "Responsibility Center Card BR";
                ToolTip = 'Executes the Conformation Of Work action.';
            }
        }
    }
}

