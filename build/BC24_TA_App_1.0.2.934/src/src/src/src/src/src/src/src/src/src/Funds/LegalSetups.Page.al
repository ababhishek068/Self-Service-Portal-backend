Page 50648 "Legal Setups"
{
    DeleteAllowed = false;
    PageType = Card;
    SourceTable = "Security Setups";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(LegalNos; Rec."Legal Nos")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Legal Nos field.';
                }
                field("Litigation Nos"; Rec."Letigation Nos")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Letigation Nos field.';
                }
                field(CorporateNo; Rec."Corporate No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Corporate No. field.';
                }
                field("Case Nos"; Rec."Case Nos")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Case Nos field.';
                }
            }
        }
    }

    actions { }
}

