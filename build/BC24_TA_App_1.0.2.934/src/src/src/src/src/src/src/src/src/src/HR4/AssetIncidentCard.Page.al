Page 50376 "Asset Incident Card"
{
    PageType = Card;
    SourceTable = "Asset Incident";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(IncidentNo; Rec."Incident No.")
                {
                    ApplicationArea = Basic;
                    ShowMandatory = true;
                    Style = Strong;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Incident No. field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    ShowMandatory = true;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(IncidentType; Rec."Incident Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Incident Type field.';
                }
                field(ReportedBy; Rec."Reported By")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Style = AttentionAccent;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Reported By field.';
                }
                field(DateReported; Rec."Date Reported")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Date Reported field.';
                }
                field(Dimension1Code; Rec."Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Dimension 1 Code field.';
                }
                field(Dimension2Code; Rec."Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Dimension 2 Code field.';
                }
                field(Location; Rec.Location)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Location field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    Style = Attention;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field(Recommendations; Rec.Recommendations)
                {
                    ApplicationArea = Basic;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Recommendations field.';
                }
            }
            part(Control12; "Asset Incident Lines")
            {
                SubPageLink = "Incident No." = field("Incident No.");
                UpdatePropagation = Both;
            }
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

                    if Confirm('Send this Maintenance for Approval?', true) = false then exit;

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
                    if Confirm('Cancel Approval Request for this Maintenance?', true) = false then exit;

                    //ApprovalMgt.CancelAssetTransAppRequest(Rec,TRUE,TRUE);
                end;
            }
        }
    }
}

