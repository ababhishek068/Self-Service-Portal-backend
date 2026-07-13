page 51103 "PR Payroll Access Rights"
{

    Caption = 'PR Payroll Access Rights';
    PageType = List;
    SourceTable = "PR Payroll Access Rights";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the User ID field.';
                }
                field(Authorized; Rec.Authorized)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Authorized field.';
                }

                field("Last Modified By"; Rec."Last Modified By")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Last Modified By field.';
                }

                field("Last DateTime Modified"; Rec."Last DateTime Modified")
                {

                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Last Modified DateTime field.';
                }
            }
        }
    }

}
