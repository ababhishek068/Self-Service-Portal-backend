Page 50127 "Customer Modules"
{
    DeleteAllowed = false;
    PageType = List;
    SourceTable = "Client Modules";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Customer; Rec.Customer)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Customer field.';
                }
                field(Module; Rec.Module)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Module field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Description field.';
                }
            }
        }
    }

    actions { }
}

