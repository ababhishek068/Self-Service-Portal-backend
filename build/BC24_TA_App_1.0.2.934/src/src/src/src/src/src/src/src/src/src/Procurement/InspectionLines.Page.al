
Page 51506 "Inspection Lines"
{
    PageType = ListPart;
    SourceTable = "Inspection Lines";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Item No.";"Item No.")
                {
                    ApplicationArea = Basic;
                    Editable=false;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    Editable=false;
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = Basic;
                    Editable=false;
                }
                field("Quantity Passed Inspection";"Quantity Passed Inspection")
                {
                    ApplicationArea=basic;
                    trigger OnValidate()
                    begin
                        TestField(Quantity);
                        if "Quantity Passed Inspection">Quantity then
                        Error('Quantity to inspect cannot be more than quantity');
                        
                    end;
                }
                field(UoM;UoM)
                {
                    ApplicationArea = Basic;
                    Editable=false;
                }
                field("Unit Cost";"Unit Cost")
                {
                    ApplicationArea = Basic;
                    Editable=false;
                }
                field("Total Cost";"Total Cost")
                {
                    ApplicationArea = Basic;
                    Editable=false;
                }
                
            }
        }
    }

    actions
    {
    }
}

