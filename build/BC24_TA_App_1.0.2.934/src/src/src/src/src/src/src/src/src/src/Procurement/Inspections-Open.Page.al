#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 51507 "Inspections - Open"
{
    Caption = 'New Inspections';
    CardPageID = "Inspction Card";
    DeleteAllowed = false;
    PageType = List;
    SourceTable = "Inspection Header";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(No;No)
                {
                    ApplicationArea = Basic;
                }
                field("Created By";"Created By")
                {
                    ApplicationArea = Basic;
                }
                field("LPO No";"LPO No")
                {
                    ApplicationArea = Basic;
                }
                field("Supplier No.";"Supplier No.")
                {
                    ApplicationArea = Basic;
                }
                field("Supplier Name";"Supplier Name")
                {
                    ApplicationArea = Basic;
                }
                field(Date;Date)
                {
                    ApplicationArea = Basic;
                }
                field("RFQ No.";"RFQ No.")
                {
                    ApplicationArea = Basic;
                }
                field("RFQ Date";"RFQ Date")
                {
                    ApplicationArea = Basic;
                }
                field("LPO Date";"LPO Date")
                {
                    ApplicationArea = Basic;
                }
                field("Total Value";"Total Value")
                {
                    ApplicationArea = Basic;
                }
                field("Invoice No.";"Invoice No.")
                {
                    ApplicationArea = Basic;
                }
                field("D Note No.";"D Note No.")
                {
                    ApplicationArea = Basic;
                }
                field("Completion/Delivery Date";"Completion/Delivery Date")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }
}

