page 51147 "Company Workplan Lines"
{
    Editable = false;
    InsertAllowed = false;
    DeleteAllowed = false;
    PageType = ListPart;
    SourceTable = "Company Workplan Lines";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Procurement Workplan Code"; Rec."Procurement Workplan Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Procurement Workplan Code field.';
                }

                field("Activity Code"; Rec."Activity Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Activity Code field.';
                }

                field("Unit of Measure"; Rec."Unit of Measure")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Unit of Measure field.';
                }

                field("Activity Description"; Rec."Activity Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Activity Description field.';
                }

                field("Category Sub Plan"; Rec."Category Sub Plan")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Category Sub Plan field.';
                }

                field("Account Type"; Rec."Account Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Account Type field.';
                }

                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Type field.';
                }

                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. field.';
                }

                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description field.';
                }

                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.';
                }

                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Global Dimension 2 Code field.';
                }

                field("Procurement Method"; Rec."Procurement Method")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Procurement Method field.';
                }

                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Quantity field.';
                }

                field("Unit of Cost"; Rec."Unit Cost")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Unit Cost field.';
                }

                field("Amount to Transfer"; Rec."Amount to Transfer")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Amount to Transfer field.';
                }

                field("Date to Transfer"; Rec."Date to Transfer")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Date to Transfer field.';
                }

                field("Converted to G/L Budget"; Rec."Converted to G/L Budget")
                {
                    //Editable = false;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Converted to G/L Budget field.';
                }
            }
        }

    }
}