Report 50261 "Delivery Note"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/DeliveryNote.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("Sales Invoice Header"; "Sales Invoice Header")
        {
            RequestFilterFields = "No.";
            column(ReportForNavId_1; 1) { }
            column(Bill_to_Customer_No_; "Bill-to Customer No.") { }
            column(Bill_to_Name; "Bill-to Name") { }
            column(Bill_to_Address; "Bill-to Address") { }
            column(Bill_to_Contact; "Bill-to Contact") { }
            column(Posting_Date; "Posting Date") { }
            column(Posting_Description; "Posting Description") { }

            column(CompName; CompInf.Name) { }
            column(CompLogo; CompInf.Picture) { }
            column(CompAdd1; CompInf.Address) { }
            column(CompAdd2; CompInf."Address 2") { }
            column(TruckNO; "Shipping Agent Code") { }
            column(DriverName; "Ship-to Address") { }
            column(DriverID; "Ship-to Address 2") { }
            column(Transporter; "Ship-to Name") { }
            dataitem("Sales Invoice Line"; "Sales Invoice Line")
            {
                DataItemLink = "Document No." = field("No.");
                //DataItemLink = No = field("No."), "Posting Date" = field("Date Filter");
                //DataItemTableView = sorting("Customer No.", "Posting Date") order(ascending) where("Entry Type" = filter("Initial Entry"), Reversed = const(false), "Cust. Ledger Entry No." = filter(> 0));

                column(No_; "No.") { }
                column(Document_No_; "Document No.") { }
                column(Type; Type) { }
                column(Description; Description) { }
                column(Quantity; Quantity) { }
                column(Amount; Amount) { }
                column(Amount_Including_VAT; "Amount Including VAT") { }
                column(VAT__; "VAT %") { }
                column(VAT_Base_Amount; "VAT Base Amount") { }
                column(Driver_No; "Driver No") { }
                column(Truck_No; "Truck No") { }

                column(Unit_of_Measure_Code; "Unit of Measure Code") { }
                column(PurchaseUnitofMeasure; Item."Purch. Unit of Measure") { }

                column(AdditionalConvRate; Item."Additional Convertion Rate") { }

                trigger OnAfterGetRecord()
                begin
                    if Item.get("No.") then;
                    //"Detailed Cust. Ledg. Entry".CalcFields(Stage);
                    //RuningBal := RuningBal + "Detailed Cust. Ledg. Entry"."Amount (LCY)";

                end;
            }

            trigger OnAfterGetRecord()

            begin

                RuningBal := 0;

            end;

            trigger OnPreDataItem()
            begin
                CompInf.Get;
                CompInf.CalcFields(CompInf.Picture);
            end;
        }
    }

    requestpage
    {

        layout { }

        actions { }
    }

    labels { }

    var
        //Sem: Record Semesters;
        CompInf: Record "Company Information";
        RuningBal: Decimal;
        Item: Record Item;
}

