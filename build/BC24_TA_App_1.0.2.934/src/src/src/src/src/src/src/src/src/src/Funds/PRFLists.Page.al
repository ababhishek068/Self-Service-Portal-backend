Page 50525 "PRF Lists"
{
    PageType = List;
    SourceTable = "Purchase Line";
    SourceTableView = where("Document Type" = const(Quote));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(DocumentNo; Rec."Document No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the document number.';
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the line type.';
                }
                field(No; Rec."No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a description of the blanket purchase order.';
                }
                field(Description2; Rec."Description 2")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies information in addition to the description.';
                }
                field(UnitofMeasure; Rec."Unit of Measure")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of the item or resource''s unit of measure, such as piece or hour.';
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the quantity of the purchase order line.';
                }
                field(DirectUnitCost; Rec."Direct Unit Cost")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the cost of one unit of the selected item or resource.';
                }
            }
        }
    }

    actions { }

    procedure SetSelection(var Collection: Record "Purchase Line")
    begin
        CurrPage.SetSelectionFilter(Collection);
    end;
}

