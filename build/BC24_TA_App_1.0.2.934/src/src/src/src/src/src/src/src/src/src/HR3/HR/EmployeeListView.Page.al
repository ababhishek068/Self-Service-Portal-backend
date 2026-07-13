page 51338 "Employee List View"
{

    ApplicationArea = All;
    Caption = ' HR Employees';
    PageType = List;
    Editable = false;
    PromotedActionCategories = 'New,Process,Report,Functions';
    SourceTable = "HR-Employee";
    UsageCategory = Lists;


    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Payroll No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. field.';
                }

                field("First Name"; Rec."First Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the First Name field.';
                }
                field("Last Name"; Rec."Last Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Last Name field.';
                }

                field("Full Name"; Rec."Full Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Full Name field.';
                }




                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the User ID field.';
                }



            }

        }

    }


}