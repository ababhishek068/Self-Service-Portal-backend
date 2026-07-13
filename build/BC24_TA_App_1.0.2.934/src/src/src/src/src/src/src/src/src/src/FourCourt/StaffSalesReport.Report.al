report 50327 "Staff Sales Report"
{
    UsageCategory = Administration;
    ApplicationArea = All;

    dataset
    {
        dataitem("Pump Reading Line"; "Pump Reading Line")
        {
            RequestFilterFields = "Station Code", "Staff No", "Shift No", Date;

            column(Date; PumpH.Date) { }
            column(No; PumpH.No) { }
            column(Total_Reading_Amount; PumpH."Total Reading Amount") { }
            column(Staff_Name; PumpH."Staff Name") { }
            column(Total_Invoice_Amount; PumpH."Total Invoice Amount") { }
            column(Total_Pump_Return_Amount; PumpH."Total Pump Return Amount") { }
            column(Total_MPESA_Amount; PumpH."Total MPESA Amount") { }
            column(Total_Cash_Amount; PumpH."Total Cash Amount") { }
            column(Total_PDQ_Amount; PumpH."Total PDQ Amount") { }
            column(Total_Expenditure_Amount; PumpH."Total Expenditure") { }
            column(Pump_Code; "Pump Code") { }
            column(Total_PumpOut_Amount; PumpH."Total PumpOut Amount") { }
            column(Staff_No; "Staff No") { }
            column(PumpsDesc; PumpsRec.Description) { }
            column(CompInfLogo; CompInf.Picture) { }
            column(CompInfName; CompInf.Name) { }
            column(InvAmt1; InvAmt[1]) { }
            column(InvAmt2; InvAmt[2]) { }
            column(InvAmt3; InvAmt[3]) { }
            column(InvAmt4; InvAmt[4]) { }
            column(InvAmt5; InvAmt[5]) { }

            column(TruckDriv1; TruckDriv[1]) { }
            column(TruckDriv2; TruckDriv[2]) { }
            column(TruckDriv3; TruckDriv[3]) { }
            column(TruckDriv4; TruckDriv[4]) { }
            column(TruckDriv5; TruckDriv[5]) { }
            column(CustName1; CustName[1]) { }
            column(CustName2; CustName[2]) { }
            column(CustName3; CustName[3]) { }
            column(CustName4; CustName[4]) { }
            column(CustName5; CustName[5]) { }
            column(TrucKReg1; TrucKReg[1]) { }
            column(TrucKReg2; TrucKReg[2]) { }
            column(TrucKReg3; TrucKReg[3]) { }
            column(TrucKReg4; TrucKReg[4]) { }
            column(TrucKReg5; TrucKReg[5]) { }
            column(Manual_Litres_Qty_Sold; "Manual Litres Qty Sold") { }
            column(Electronic_Cash_Qty_Sold; "Electronic Cash Qty Sold") { }
            column(Electronic_Litres_Qty_Sold; "Electronic Litres Qty Sold") { }
            column(PumpOut; PumpOut) { }
            column(PumpoutAmount; PumpoutAmount) { }
            dataitem("PumpAttendInvoiceAlloc"; "Pump Attend. Invoice Alloc.")
            {
                DataItemLinkReference = "Pump Reading Line";
                DataItemLink = No = field(No);
                column(Line_No; "Line No") { }
                column(Reg_No_; "Reg No.") { }
                column(Names; Names) { }
                column(Amount; Amount) { }
                column(Driver_Names; "Driver Names") { }

            }

            trigger OnAfterGetRecord()
            VAR
                CreditMemo: Record "Sales Cr.Memo Line";

            begin

                if PumpsRec.get("Pump Code") then;

                if PumpH.get(No) then begin
                    PumpH.CalcFields("Total Invoice Amount");
                    PumpH.CalcFields("Total Cash Amount");
                    PumpH.CalcFields("Total MPESA Amount");
                    PumpH.CalcFields("Total Reading Amount");
                    PumpH.CalcFields("Total Pump Return Amount");
                    PumpH.CalcFields("Total PDQ Amount");
                    PumpH.CalcFields("Total Expenditure");
                    PumpH.CalcFields("Total PumpOut Amount");
                    PumpH.CalcFields("Staff Name");
                end;
                i := 0;
                clear(CustName);
                Clear(TruckDriv);
                Clear(TrucKReg);
                Clear(InvAmt);
                PumpInv.reset;
                PumpInv.setrange(No, No);
                if PumpInv.find('-') then begin
                    repeat
                        i := i + 1;
                        CustName[i] := PumpInv.Names;
                        TruckDriv[i] := PumpInv."Driver Names";
                        TrucKReg[i] := PumpInv."Reg No.";
                        InvAmt[i] := PumpInv.Amount;
                    until PumpInv.next = 0;
                end;
                pumpout := 0;
                PumpoutAmount := 0;
                CreditMemo.reset;
                CreditMemo.SetRange("Sell-to Customer No.", "Staff No");
                CreditMemo.SetRange("Posting Date", Date);
                //CreditMemo.SetRange(CreditMemo."Appl.-from Item Entry", "Station Code");
                if CreditMemo.find('-') then begin
                    repeat
                        IF CreditMemo."Appl.-from Item Entry" <> 0 THEN BEGIN
                            PumpOut := CreditMemo.Quantity + PumpOut;
                            PumpoutAmount := CreditMemo."Amount Including VAT" + PumpoutAmount;
                        END;
                    until CreditMemo.Next = 0;

                end;
                salesinvhdr.Reset;
                salesinvhdr.SetRange("Shift No", "Shift No");
                salesinvhdr.SetRange("Sales Person", "Staff No");

                IF salesinvHdr.Find('-') then begin
                    repeat
                        if salesinvHdr."Bill-to Customer No." <> "Staff No" then
                            InvoicedAmnt := InvoicedAmnt + salesinvHdr."Amount Including VAT";
                    until salesinvHdr.Next = 0;

                end;

            end;
        }

    }

    trigger OnPreReport()
    begin
        CompInf.get();
        CompInf.CalcFields(Picture);
    end;

    var
        CompInf: Record "Company Information";
        PumpH: record "Pump Reading Header";
        PumpInv: Record "Pump Attend. Invoice Alloc.";
        TrucKReg: Array[20] of text[100];
        InvAmt: Array[20] of Decimal;
        CustName: Array[20] of Text[100];
        TruckDriv: Array[20] of text[100];
        PumpsRec: Record Pump;
        i: Integer;
        PumpOut: Decimal;
        PumpoutAmount: Decimal;
        salesinvHdr: Record "Sales Invoice header";
        InvoicedAmnt: Decimal;

}