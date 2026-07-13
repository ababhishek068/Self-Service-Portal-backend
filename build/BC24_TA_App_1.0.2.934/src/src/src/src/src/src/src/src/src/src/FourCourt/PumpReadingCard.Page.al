page 51434 "Pump Reading Card"
{
    PageType = Document;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Pump Reading Header";
    SourceTableView = where(Posted = filter(false));
    DeleteAllowed = false;
    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                Caption = 'General';
                field(No; Rec.No)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No field.';
                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.Update();
                    end;
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Date field.';

                }
                field("Station Code"; Rec."Station Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Station Code field.';

                }
                field("Shift No"; Rec."Shift No")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Shift No field.';

                }
                field("Staff No"; Rec."Staff No")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Staff No field.';

                }
                field("Staff Name"; Rec."Staff Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Staff Name field.';

                }
                field("Total Reading Amount"; Rec."Total Reading Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Total Reading Amount field.';

                }
                field("Total Invoice Amount"; Rec."Total Invoice Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Total Invoice Amount field.';

                }
                field("Total PumpOut Amount"; Rec."Total PumpOut Amount")
                {
                    ApplicationArea = all;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Total PumpOut Amount field.';
                }
                field("Total Pump Return Amount"; Rec."Total Pump Return Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Total Pump Return Amount field.';

                }
                field("Total Cash Amount"; Rec."Total Reading Amount" - Rec."Total Invoice Amount" - Rec."Total Pump Return Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Total Reading Amount - Rec.Total Invoice Amount - Rec.Total Pump Return Amount field.';

                }


            }
            group(Readings)
            {
                part(Lines; "Pump Reading Lines")
                {
                    caption = 'Readings';
                    SubPageLink = No = field(No);
                }
            }
        }
        area(Factboxes) { }
    }

    actions
    {
        area(Processing)
        {
            action(AllocateInv)
            {
                ApplicationArea = All;
                Caption = 'Credit Invoices Allocations';
                Promoted = true;
                Image = Invoice;
                RunObject = page "Pump Attend. Inv. Alloc.";
                RunPageLink = No = field(No);
                ToolTip = 'Executes the Credit Invoices Allocations action.';
            }
            action(PrintReading)
            {
                ApplicationArea = All;
                Caption = 'Print Reading Summary';
                Promoted = true;
                ToolTip = 'Executes the Print Reading Summary action.';
                //  Image =Report;
                trigger OnAction()
                var
                    StaffRead: Report "Staff Sales Report";
                    ReadLine: Record "Pump Reading Line";
                begin
                    ReadLine.reset;
                    ReadLine.setrange(No, Rec.No);
                    if ReadLine.find('-') then begin
                        StaffRead.SetTableView(ReadLine);
                        StaffRead.Run();
                    end;
                end;
            }
            action(Post)
            {
                ApplicationArea = All;
                Caption = 'Posting Pump Reading';
                ToolTip = 'Executes the Posting Pump Reading action.';
                trigger OnAction();
                var
                    PumpReadingLines: Record "Pump Reading Line";
                    ForeCourtSetup: Record "Fore Court Setup";
                    Pumps: Record Pump;
                    InvAlloc: Record "Pump Attend. Invoice Alloc.";
                    InvAmt: Decimal;
                    PumpAmt: Decimal;
                    Attend: Record "Salesperson/Purchaser";
                begin
                    if Confirm('Do you really want to post the reading?', false) then begin
                        Rec.TestField(Posted, false);
                        Rec.TestField("Station Code");
                        Rec.TestField("Staff No");
                        Rec.TestField(Date);

                        ForeCourtSetup.get;
                        Attend.get(Rec."Staff No");
                        Attend.TestField("Sales Account No");

                        PumpAmt := 0;
                        PumpReadingLines.reset;
                        PumpReadingLines.setrange(No, Rec.No);
                        if PumpReadingLines.find('-') then begin
                            repeat
                                PumpReadingLines.CalcFields("Max Electronic Cash Reading");
                                PumpReadingLines.CalcFields("Max Electronic Litres Reading");
                                PumpAmt := PumpAmt + (PumpReadingLines."Unit Price" * PumpReadingLines.Quantity);

                                if (PumpReadingLines."Electronic Cash Qty Sold" - PumpReadingLines."Electronic Litres Qty Sold" > ForeCourtSetup."Maximum Reading Variance") and
                                (PumpReadingLines."Max Electronic Cash Reading" <> 0) and (PumpReadingLines."Max Electronic Litres Reading" <> 0) then
                                    Error('The ' + PumpReadingLines."Pump Code" + ' electronic cash reading has registered ' + format(PumpReadingLines."Electronic Cash Qty Sold" - PumpReadingLines."Electronic Litres Qty Sold") + ' more litres than electronic litres reading');

                                if (PumpReadingLines."Electronic Cash Qty Sold" - PumpReadingLines."Electronic Litres Qty Sold" < ForeCourtSetup."Maximum Reading Variance" * -1) and
                                    (PumpReadingLines."Max Electronic Cash Reading" <> 0) and (PumpReadingLines."Max Electronic Litres Reading" <> 0) then
                                    Error('The ' + PumpReadingLines."Pump Code" + ' electronic cash reading has registered ' + format(PumpReadingLines."Electronic Cash Qty Sold" - PumpReadingLines."Electronic Litres Qty Sold") + ' less litres than electronic litres reading');

                                if (PumpReadingLines."Electronic Litres Qty Sold" - PumpReadingLines."Manual Litres Qty Sold" > ForeCourtSetup."Maximum Reading Variance") and
                                     (PumpReadingLines."Max Electronic Litres Reading" <> 0) and (PumpReadingLines."Max Manual Litres Reading" <> 0) then
                                    Error('The ' + PumpReadingLines."Pump Code" + ' electronic litres reading has registered ' + format(PumpReadingLines."Electronic Litres Qty Sold" - PumpReadingLines."Manual Litres Qty Sold") + ' more litres than manual litres reading');

                                if (PumpReadingLines."Electronic Litres Qty Sold" - PumpReadingLines."Manual Litres Qty Sold" < ForeCourtSetup."Maximum Reading Variance" * -1) and
                                     (PumpReadingLines."Max Electronic Litres Reading" <> 0) and (PumpReadingLines."Max Manual Litres Reading" <> 0) then
                                    Error('The ' + PumpReadingLines."Pump Code" + ' electronic litres reading has registered ' + format(PumpReadingLines."Electronic Litres Qty Sold" - PumpReadingLines."Manual Litres Qty Sold") + ' less litres than manual litres reading');

                                if (PumpReadingLines."Electronic Cash Qty Sold" - PumpReadingLines."Manual Litres Qty Sold" > ForeCourtSetup."Maximum Reading Variance") and
                                                                (PumpReadingLines."Max Electronic Cash Reading" <> 0) and (PumpReadingLines."Max Manual Litres Reading" <> 0) then
                                    Error('The ' + PumpReadingLines."Pump Code" + ' electronic cash reading has registered ' + format(PumpReadingLines."Electronic Litres Qty Sold" - PumpReadingLines."Manual Litres Qty Sold") + ' more litres than manual litres reading');

                                if (PumpReadingLines."Electronic Cash Qty Sold" - PumpReadingLines."Manual Litres Qty Sold" < ForeCourtSetup."Maximum Reading Variance" * -1) and
                                                                                             (PumpReadingLines."Max Electronic Cash Reading" <> 0) and (PumpReadingLines."Max Manual Litres Reading" <> 0) then
                                    Error('The ' + PumpReadingLines."Pump Code" + ' electronic cash reading has registered ' + format(PumpReadingLines."Electronic Litres Qty Sold" - PumpReadingLines."Manual Litres Qty Sold") + ' less litres than manual litres reading');

                                //  PostItems();
                                InvAlloc.reset;
                                InvAlloc.setrange(No, Rec.No);
                                if InvAlloc.find('-') then begin
                                    repeat
                                        InvAmt := InvAmt + InvAlloc.Amount;
                                    until InvAlloc.next = 0;
                                end;


                                if Pumps.get(PumpReadingLines."Pump Code") then begin
                                    //  if (PumpReadingLines."Electronic Cash"+Pumps."Last Elecl. Cash Reading")>Pumps."Max Electronic Cash Reading" then

                                    Pumps."Last Elecl. Cash Reading" := PumpReadingLines."Electronic Cash";
                                    pumps."Last Elecl. Litres Reading" := PumpReadingLines."Electronic Litres";
                                    pumps."Last Manual Litres Reading" := PumpReadingLines."Manual Litres";
                                    Pumps.modify;
                                end;

                            until PumpReadingLines.next = 0;
                        end;

                        Rec.CalcFields("Total Invoice Amount");
                        Rec.CalcFields("Total Reading Amount");
                        if Rec."Total Invoice Amount" > Rec."Total Reading Amount" then
                            error('Please note the invoice amount cannot be more than pump reading amount');
                        IF Rec."Total Reading Amount" = 0 then
                            error('There is nothing to Post on this pump reading');



                        InvAlloc.reset;
                        InvAlloc.setrange(No, Rec.No);
                        InvAlloc.setrange(Suggested, false);
                        if InvAlloc.find('-') then begin
                            repeat
                                if InvAlloc.Amount > 0 then
                                    GenerateInvoice(InvAlloc."Customer No", InvAlloc."Line No", false);
                            until InvAlloc.next = 0;
                        end;
                        GenerateInvoice(Attend."Sales Account No", 0, true);

                        Rec.Posted := true;
                        Rec."Posted By" := UserId;
                        Rec."Posting Date" := today;
                        Rec.Modify();
                    end;
                end;
            }
        }
    }
    procedure PostItems()
    var
        ForeCourt: Record "Fore Court Setup";
        ItemJnlLine: Record "Item Journal Line";
        PumpLine: Record "Pump Reading Line";
        LineNo: Integer;
    begin


        ForeCourt.get;
        ForeCourt.TestField("Item Journal Template");
        ForeCourt.TestField("Item Journal Batch");
        ItemJnlLine.Reset;
        ItemJnlLine.SetRange(ItemJnlLine."Journal Template Name", ForeCourt."Item Journal Template");
        ItemJnlLine.SetRange(ItemJnlLine."Journal Batch Name", ForeCourt."Item Journal Batch");
        if ItemJnlLine.Find('-') then ItemJnlLine.DeleteAll;
        LineNo := 0;
        PumpLine.Reset;
        PumpLine.SetRange(PumpLine.No, Rec.No);
        if PumpLine.Find('-') then begin

            repeat
                LineNo := LineNo + 1000;
                ItemJnlLine.Init;
                ItemJnlLine."Journal Template Name" := ForeCourt."Item Journal Template";
                ItemJnlLine."Journal Batch Name" := ForeCourt."Item Journal Batch";
                ItemJnlLine."Line No." := LineNo;
                ItemJnlLine."Posting Date" := Today;
                ItemJnlLine."Entry Type" := ItemJnlLine."Entry Type"::Sale;
                ItemJnlLine."Document No." := PumpLine.No + ':' + PumpLine."Pump Code";
                ItemJnlLine."Item No." := PumpLine."Fuel Type";
                ItemJnlLine.Validate(ItemJnlLine."Item No.");
                ItemJnlLine."Location Code" := PumpLine."Tank Code";
                ItemJnlLine.Validate(ItemJnlLine."Location Code");
                ItemJnlLine.Quantity := PumpLine.Quantity;
                ItemJnlLine.Validate(ItemJnlLine.Quantity);
                PumpLine.CalcFields("Unit of Measure");
                ItemJnlLine."Unit of Measure Code" := PumpLine."Unit of Measure";
                ItemJnlLine.Validate(ItemJnlLine."Unit of Measure Code");
                ItemJnlLine."Unit Amount" := PumpLine."Unit Price";
                ItemJnlLine."Shortcut Dimension 1 Code" := PumpLine."Station Code";
                // ItemJnlLine."Shortcut Dimension 2 Code" := '01-02-D031';
                // ItemJnlLine.VALIDATE(ItemJnlLine."Unit Amount");
                ItemJnlLine.Validate("Shortcut Dimension 1 Code");
                // ItemJnlLine.Validate("Shortcut Dimension 2 Code");
                ItemJnlLine.Insert();

                LineNo := LineNo + 1;

            until PumpLine.Next = 0;

            ItemJnlLine.Reset;
            ItemJnlLine.SetRange("Journal Template Name", ForeCourt."Item Journal Template");
            ItemJnlLine.SetRange("Journal Batch Name", ForeCourt."Item Journal Batch");
            if ItemJnlLine.Find('-') then
                CODEUNIT.Run(CODEUNIT::"Item Jnl.-Post Batch", ItemJnlLine);

        end;

    end;

    procedure GetNewInvoiceNumber(BranchNo: code[20]): Code[20]
    var
        DimRec: Record "Dimension Value";
        NewCode: code[20];
        SalesSetup: Record "Sales & Receivables Setup";
        NoSeriesMgt: Codeunit "No. Series";
    begin
        SalesSetup.get;
        dimrec.reset;
        dimrec.setrange(Code, BranchNo);
        if DimRec.find('-') then begin
            /* if dimrec."Invoice No. Series" <> '' then
                NewCode := NoSeriesMgt.GetNextNo(dimrec."Invoice No. Series", 0D, TRUE)
            else */
            NewCode := NoSeriesMgt.GetNextNo(SalesSetup."Invoice Nos.", 0D, TRUE);
        end;
        exit(NewCode);
    end;

    procedure GenerateInvoice(CustNo: code[20]; Ln: Integer; IsAttendace: boolean)
    var
        SaleH: Record "Sales Header";
        NewNo: code[20];
        SalesSetup: Record "Sales & Receivables Setup";
        SLine: Record "Sales Line";
        LineNo: Integer;
        PumpReadingLine: Record "Pump Reading Line";
        InvAllocLine: record "Pump Attend. Invoice Alloc.";
        InvQty: Decimal;
        InvAmt: Decimal;
        ReQty: Decimal;
        ReAmt: Decimal;
        DiscAmt: Decimal;
        FuelType: record "Fuel Type";
        ForeCourtSetup: record "Fore Court Setup";
    begin

        ForeCourtSetup.get;
        NewNo := GetNewInvoiceNumber(Rec."Station Code");
        SaleH.Init;
        SaleH."Document Type" := SaleH."document type"::Invoice;
        SaleH."No." := NewNo;
        SaleH."Posting Date" := Rec.Date;
        SaleH."Due Date" := CalcDate('3M', Rec.Date);
        SaleH."Shipping No. Series" := SalesSetup."Posted Shipment Nos.";
        SaleH."Document Date" := Today;
        SaleH."Sell-to Customer No." := CustNo;
        SaleH."Bill-to Customer No." := CustNo;
        SaleH."Shortcut Dimension 1 Code" := Rec."Station Code";
        SaleH."Salesperson Code" := Rec."Staff No";
        SaleH."Shortcut Dimension 2 Code" := ForeCourtSetup."ForeCourt Department";

        SaleH."Shipping No. Series" := SalesSetup."Posted Shipment Nos.";
        SaleH."External Document No." := Rec.No;
        SaleH.Insert;
        //END;

        if SaleH.Get(SaleH."Document type"::Invoice, NewNo) then begin
            SaleH.Validate("Sell-to Customer No.");
            SaleH."Shortcut Dimension 1 Code" := Rec."Station Code";
            // SaleH."Shortcut Dimension 2 Code" := Attend."Global Dimension 2 Code";


            SaleH.Validate("Shortcut Dimension 1 Code");
            SaleH.Validate("Shortcut Dimension 2 Code");
            //SaleH.Status := SaleH.Status::Released;
            SaleH.modify;

            if SLine.FindLast() then LineNo := SLine."Line No." + 1;
            if IsAttendace = true then begin
                FuelType.reset;
                if FuelType.find('-') then begin
                    repeat
                        // if Itm.get(PumpReadingLine."Fuel Type") and (PumpReadingLine.Quantity > 0) then begin
                        SLine.Init;
                        SLine."Line No." := LineNo;
                        SLine."Document No." := SaleH."No.";
                        SLine."Bill-to Customer No." := SaleH."Bill-to Customer No.";
                        SLine."Document Type" := SaleH."Document Type";
                        SLine."Sell-to Customer No." := CustNo;
                        SLine.Type := SLine.Type::Item;
                        SLine."No." := FuelType.Code;
                        sline.Validate("No.");
                        SLine.Description := FuelType.Description;
                        InvQty := 0;
                        InvAmt := 0;
                        InvAllocLine.reset;
                        InvAllocLine.setrange(No, Rec.No);
                        InvAllocLine.setrange(Suggested, false);
                        InvAllocLine.setrange("Fuel Type", FuelType.Code);
                        If InvAllocLine.find('-') then begin
                            repeat
                                InvQty := InvQty + InvAllocLine.Quantity;
                                InvAmt := InvAmt + InvAllocLine.Amount;
                            until InvAllocLine.next = 0;
                        end;
                        ReQty := 0;
                        ReAmt := 0;
                        PumpReadingLine.reset;
                        PumpReadingLine.setrange(No, Rec.No);
                        PumpReadingLine.setrange("Fuel Type", FuelType.Code);
                        If PumpReadingLine.find('-') then begin
                            repeat
                                Sline."Location Code" := PumpReadingLine."Tank Code";
                                ReQty := ReQty + PumpReadingLine.Quantity - PumpReadingLine."Tank Return Quantity";
                                ReAmt := ReAmt + PumpReadingLine.Amount - PumpReadingLine."Tank Return Amount";
                            until PumpReadingLine.next = 0;
                        end;
                        if InvQty > ReQty then
                            error('Invoice Qty can not be more than Pump reading Qty on ' + FuelType.code);
                        SLine.Quantity := ReQty - InvQty;
                        if (ReAmt > 0) and (ReQty > 0) then
                            SLine."Unit Price" := (ReAmt - InvAmt) / (ReQty - InvQty);
                        SLine.Validate(SLine.Quantity);
                        SLine.Validate("Unit Price");
                        Sline.Amount := ReAmt - InvAmt;
                        SLine."Truck No" := InvAllocLine."Reg No.";
                        SLine."Driver No" := InvAllocLine."Driver Names";

                        SLine."Shortcut Dimension 1 Code" := Rec."Station Code";
                        sline."Shortcut Dimension 2 Code" := ForeCourtSetup."ForeCourt Department";
                        SLine.Validate("Shortcut Dimension 1 Code");
                        SLine.Validate("Shortcut Dimension 2 Code");
                        SLine.Validate("VAT Prod. Posting Group");
                        if SLine.Quantity > 0 then
                            SLine.Insert;
                        LineNo := LineNo + 1;

                    // END;
                    until FuelType.Next = 0;
                end;
            end;
            if IsAttendace = false then begin
                FuelType.reset;
                if FuelType.find('-') then begin
                    repeat
                        SLine.Init;
                        SLine."Line No." := LineNo;
                        SLine."Document No." := SaleH."No.";
                        SLine."Bill-to Customer No." := SaleH."Bill-to Customer No.";
                        SLine."Document Type" := SaleH."Document Type";
                        SLine."Sell-to Customer No." := CustNo;
                        SLine.Type := SLine.Type::Item;
                        SLine."No." := FuelType.Code;
                        sline.Validate("No.");
                        SLine.Description := FuelType.Description;
                        InvQty := 0;
                        InvAmt := 0;
                        DiscAmt := 0;
                        InvAllocLine.reset;
                        InvAllocLine.setrange(No, Rec.No);
                        InvAllocLine.setrange(Suggested, false);
                        InvAllocLine.setrange("Fuel Type", FuelType.Code);
                        InvAllocLine.setrange("Customer No", CustNo);
                        InvAllocLine.setrange("Line No", Ln);
                        If InvAllocLine.find('-') then begin
                            repeat
                                InvQty := InvQty + InvAllocLine.Quantity;
                                InvAmt := InvAmt + InvAllocLine.Amount;
                                DiscAmt := DiscAmt + InvAllocLine."Discount Amount";
                            until InvAllocLine.next = 0;
                        end;
                        SLine.Quantity := InvQty;
                        if (InvAmt > 0) and (InvQty > 0) then
                            SLine."Unit Price" := InvAmt / InvQty;
                        SLine.Validate(SLine.Quantity);
                        SLine.Validate("Unit Price");
                        Sline.Amount := InvAmt;
                        sline."Line Discount Amount" := DiscAmt;
                        SLine."Truck No" := InvAllocLine."Reg No.";
                        SLine."Driver No" := InvAllocLine."Driver Names";
                        PumpReadingLine.reset;
                        PumpReadingLine.setrange(No, Rec.No);
                        PumpReadingLine.setrange("Fuel Type", FuelType.Code);
                        If PumpReadingLine.find('-') then begin
                            Sline."Location Code" := PumpReadingLine."Tank Code";
                        end;
                        SLine."Shortcut Dimension 1 Code" := Rec."Station Code";
                        SLine.Validate("Shortcut Dimension 1 Code");
                        SLine."Shortcut Dimension 2 Code" := ForeCourtSetup."ForeCourt Department";
                        SLine.Validate("Shortcut Dimension 2 Code");
                        SLine.Validate("VAT Prod. Posting Group");
                        if SLine.Quantity > 0 then
                            SLine.Insert;
                        LineNo := LineNo + 1;
                    until FuelType.next = 0;
                end;
            end;






        end;
        if SaleH.Get(SaleH."Document Type"::Invoice, NewNo) then
            if IsAttendace = true then
                Page.Run(43, SaleH);
    end;
}





