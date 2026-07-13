Page 50703 "Tender List"
{
    CardPageID = "Tender Card";
    Editable = false;
    PageType = List;
    SourceTable = "Tender";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(TenderID; Rec."Tender ID")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Tender ID field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(Open; Rec.Open)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Open field.';
                }
                field(ValidFrom; Rec."Valid From")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Valid From field.';
                }
                field(ValidTo; Rec."Valid To")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Valid To field.';
                }
            }
        }
    }

    actions { }
}

