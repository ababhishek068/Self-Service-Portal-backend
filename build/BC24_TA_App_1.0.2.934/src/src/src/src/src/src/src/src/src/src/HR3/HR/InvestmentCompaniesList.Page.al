Page 50790 "Investment Companies List"
{
    CardPageID = "Investment Firms Card";
    PageType = List;
    SourceTable = "Investment Company";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(CompanyCode; Rec."Company Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Company Code field.';
                }
                field(CompanyName; Rec."Company Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Company Name field.';
                }
                field(CompanyBranchCode; Rec."Company Branch Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Company Branch Code field.';
                }
                field(CompanyBranchName; Rec."Company Branch Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Company Branch Name field.';
                }
                field(Address; Rec.Address)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Address field.';
                }
                field(City; Rec.City)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the City field.';
                }
                field(Telephone; Rec.Telephone)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Telephone field.';
                }
                field(EMail; Rec."E-Mail")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the E-Mail field.';
                }
                field(PostCode; Rec."Post Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Post Code field.';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control13; MyNotes) { }
            systempart(Control14; Links) { }
        }
    }

    actions { }
}

