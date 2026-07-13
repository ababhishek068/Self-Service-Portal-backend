page 50130 "EOI Submissions"
{
    PageType = ListPart;
    Caption = 'Expression of Intrest Responses';
    SourceTable = "EOI Bids";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Document No. field.';
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Vendor No. field.';
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Vendor Name field.';
                }
                field("Submitted On"; Rec."Submitted On")
                {
                    ApplicationArea = all;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Submitted On field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Status field.';
                }
            }

        }
    }
    actions
    {
        area(processing)
        {
            action(Award)
            {
                Image = Certificate;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = basic;
                ToolTip = 'Executes the Award action.';

                trigger OnAction()
                var
                    QuoteVendors: Record "Quotation Request Vendors";
                begin
                    IF CONFIRM('Are you sure you want to assign RFP ' + Rec."Document No." + ' to Vendor ' + Rec."Vendor No." + '(' + Rec."Vendor Name" + ')?') = TRUE THEN BEGIN
                        Rec.Status := Rec.Status::Success;
                        Rec."Actioned By" := UserId;
                        Rec."Actioned On" := CreateDateTime(Today, time);
                        Rec.Modify();
                        QuoteVendors.Reset();
                        QuoteVendors.SetRange("Vendor No.", Rec."Vendor No.");
                        QuoteVendors.SetRange("Requisition Document No.", Rec."Document No.");
                        if not QuoteVendors.Find('-') then begin
                            QuoteVendors.Init();
                            QuoteVendors."Document Type" := QuoteVendors."Document Type"::"Quotation Request";
                            QuoteVendors."Vendor No." := Rec."Vendor No.";
                            QuoteVendors."Requisition Document No." := Rec."Document No.";
                            QuoteVendors.Insert();
                        end;
                        Message('Success');
                    end else
                        Error('Process Aborted');
                end;
            }
            action(Reject)
            {
                Image = Reject;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = basic;
                ToolTip = 'Executes the Reject action.';
                trigger OnAction()
                var
                begin
                    IF CONFIRM('Are you sure you want to reject RFP ' + Rec."Document No." + ' to Vendor ' + Rec."Vendor No." + '(' + Rec."Vendor Name" + ')?') = TRUE THEN BEGIN
                        Rec.Status := Rec.Status::Dropped;
                        Rec."Actioned By" := UserId;
                        Rec."Actioned On" := CreateDateTime(Today, time);
                        Rec.Modify();
                        Message('Success');
                    end else
                        Error('Process Aborted');
                end;
            }
            action(Attachments)
            {
                Image = Attachments;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = basic;
                RunObject = page "Document Attachment Details";
                RunPageLink = "No." = field("No.");
                ToolTip = 'Executes the Attachments action.';
                trigger OnAction()
                var
                begin

                end;
            }
        }
    }
}