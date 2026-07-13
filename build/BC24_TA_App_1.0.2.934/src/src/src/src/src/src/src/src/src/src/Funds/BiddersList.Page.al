namespace Microsoft;

page 51493 "Bidders List"
{
    ApplicationArea = All;
    Caption = 'Bidders List';
    PageType = ListPart;
    SourceTable = Bidders;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Tender ID"; Rec."Tender ID")
                {
                    ToolTip = 'Specifies the value of the Tender ID field.', Comment = '%';
                    Editable = false;
                }
                field("TIN No."; Rec."TIN No.")
                {
                    ToolTip = 'Specifies the value of the TIN No. field.', Comment = '%';
                }
                field("Tenderer Names"; Rec."Tenderer Names")
                {
                    ToolTip = 'Specifies the value of the Tenderer Names field.', Comment = '%';
                }
                field("Collection Represe Names";"Collection Represe Names"){}
                field("Telephone No";"Telephone No"){}
                field("Company E-mail";"Company E-mail"){}
                field("Bank Slip Ref No";"Bank Slip Ref No"){}
                field("Bank Slip Name";"Bank Slip Name"){}
                field("Non Refundable Fee";"Non Refundable Fee"){}
                field("Bank Slip Verified";"Bank Slip Verified"){}
                field("Submitted By";"Submitted By"){}
                field(Submitted;Submitted){}
                field("Rpresentative at Openning";"Rpresentative at Openning"){}
                field("Present on Opening";"Present on Opening"){}
                field("Compliance documents verified?";"Compliance documents verified?"){}                
                field("Security Bond Amount"; Rec."Security Bond Amount")
                {
                    Visible=true;
                    ToolTip = 'Specifies the value of the Security Bond Amount field.', Comment = '%';
                }
                field("Bid Amount";"Bid Amount"){
                    Visible=false;
                }
                field("Bid Bond Bank";"Bid Bond Bank"){}
                field("Bid Bond Bank Ref No";"Bid Bond Bank Ref No"){}
                field("Bid Bond Verified";"Bid Bond Verified"){}
                field("Technical Evaluation Score";"Technical Evaluation Score"){}
                field("Non-Technical Score";"Non-Technical Score"){}
                field("Financial Score";"Financial Score"){}
                field("Final Score";"Final Score"){}
                field("Perfomance Bond"; Rec."Perfomance Bond")
                {
                    Visible=false;
                    ToolTip = 'Specifies the value of the Perfomance Bond field.', Comment = '%';
                }                
                field("Receipt No."; Rec."Receipt No.")
                {
                    Visible=false;
                    ToolTip = 'Specifies the value of the Receipt No. field.', Comment = '%';
                }
                field("Serial No"; Rec."Serial No")
                {
                    Visible=false;
                    ToolTip = 'Specifies the value of the Serial No field.', Comment = '%';
                }
                field(Status; Rec.Status)
                {
                    Visible=false;
                    ToolTip = 'Specifies the value of the Status field.', Comment = '%';
                }
                field("Posted To Portal"; Rec."Posted To Portal")
                {
                    Visible=false;
                    ToolTip = 'Specifies the value of the Posted To Portal field.', Comment = '%';
                }
                field("Vendor Number";"Vendor Number"){Visible=false;}
                field("Bid fail stage";"Bid fail stage"){}
                field("Reason for fail";"Reason for fail"){}
                field("Award Status";"Award Status"){}
                field(Select;Select){}
            }
        }
    }
}
