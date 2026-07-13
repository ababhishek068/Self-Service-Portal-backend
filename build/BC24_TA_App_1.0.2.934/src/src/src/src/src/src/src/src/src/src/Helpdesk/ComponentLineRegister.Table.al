#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Table 50988 "Component Line Register"
{

    fields
    {
        field(1;"Part No";Code[30])
        {
            TableRelation = "ATM Hardware components"."Part No";

            trigger OnValidate()
            begin
                /*ObjAtmreg.SETRANGE(ObjAtmreg."Requestion No","Requestion No");
                IF ObjAtmreg.FIND('-') THEN
                  IF ObjAtmreg."Part Category"<>ObjAtmreg."Part Category"::Hardware THEN
                    ERROR('Part category must be Hardware');*/
                  if ATMHRD.Get("Part No")then
                  Description:=ATMHRD.Description;
                

            end;
        }
        field(2;Description;Text[50])
        {
        }
        field(3;Quantity;Integer)
        {
        }
        field(4;"Unit price";Decimal)
        {

            trigger OnValidate()
            begin
                "Total Amount":=Quantity*"Unit price";
            end;
        }
        field(5;"Atm No";Code[30])
        {
            TableRelation = "ATM Register."."ATM No";

            trigger OnValidate()
            begin
                atmreg.Reset;
                atmreg.SetRange(atmreg."ATM No","Atm No");
                if atmreg.Find('-') then
                  "bank abrr":=atmreg."Bank Abrreviation";
            end;
        }
        field(6;"Total Amount";Decimal)
        {
        }
        field(7;Category;Option)
        {
            OptionMembers = Hardware;
        }
        field(8;"Entry No";Integer)
        {
            AutoIncrement = true;
        }
        field(10;Status;Option)
        {
            OptionCaption = 'Working,Faulty,Repaired,Beyond Repaire';
            OptionMembers = Working,Faulty,Repaired,"Beyond Repaire";
        }
        field(11;"Requestion No";Code[30])
        {
            TableRelation = "Requisition Register-Pending"."Requestion No";
        }
        field(12;"Requestion Send";Boolean)
        {
        }
        field(13;"Item No.";Code[10])
        {
            TableRelation = Item."No.";
        }
        field(14;"To be Billed";Boolean)
        {
        }
        field(15;Barcode;Code[10])
        {

            trigger OnValidate()
            begin
                if COMPANYNAME='TECHNOLOGY ASSOCIATES EA LTD' then begin
                ///Test if item is new or refurbished.
                if (New=true) and  (Refurb=true) then begin
                  Error("Part No"+' can only be new or Refurb and not both, Kindly tick one');
                  end else if (New=false) and  (Refurb=false) then begin
                    Error("Part No"+' must be new or Refurb, Kindly tick one');
                    end  else if (New=true) and  (Refurb=false) then begin

                      end else if (New=false) and  (Refurb=true) then begin

                        end;

                //check decon availability ******Felix the ninja turtle
                if "Get from Dec"=false then begin
                if (Available=false)  then
                  Error('You cannot enter barcode when item is unavailable');
                if Barcode='' then begin
                  Ship:=false;
                  //Decommissioned:=FALSE;
                  end else if Barcode<>'' then begin
                if Barcode<>'N/M' then begin
                  barcodelenght:=StrLen(Barcode);
                  if barcodelenght<>4 then
                       Error('Barcode length cannot be greater than 4 digits');


                Validatebar.Reset;
                Validatebar.SetRange(Validatebar.Barcode,Barcode);

                if Validatebar.Find('-')then begin


                      if Validatebar."Part status"<>Validatebar."part status"::Returned then begin
                         if Validatebar."Faulty Barcode"='' then begin

                          Error(Barcode+' '+'Already exist');

                     end;
                      end;
                      pendingline.Reset;
                          pendingline.SetRange(pendingline.Barcode,Barcode);
                          if pendingline.Find('-') then begin
                            if(pendingline."Part status"<>pendingline."part status"::Returned) then begin
                              Error(Barcode+' Already exists');
                              end;
                            end;

                    end;

                    end;

                    //ATMRQ08351
                    end;
                   end else if "Get from Dec"=true then begin
                     TestField("Serial No");
                     Deccolines.Reset;
                     Deccolines.SetRange(Deccolines."Serial No","Serial No");
                     Deccolines.SetRange(Deccolines."Part No","Part No");
                     if Deccolines.Find('-') then begin
                       Deccolines.Barcode:=Barcode;
                       Deccolines.Status:=Deccolines.Status::Ok;
                       //Deccolines.MODIFY;
                       "Decom Available":='1 available in '+"Serial No";

                       end;

                     if "Decom Available"='' then begin
                       Error('You do not vailable quantity from Decommissioned machines');
                       end;
                       if Barcode='' then begin
                  Ship:=false;
                  Decommissioned:=false;
                  end else if Barcode<>'' then begin
                if Barcode<>'N/M' then begin
                  barcodelenght:=StrLen(Barcode);
                  if barcodelenght<>4 then
                       Error('Barcode length cannot be greater than 4 digits');

                  Deccolines.Reset;
                  Deccolines.SetRange(Deccolines."Serial No","Serial No");
                  Deccolines.SetRange(Deccolines."Part No","Part No");
                  //Deccolines.SETRANGE(Deccolines.Barcode,Barcode);
                  if Deccolines.Find('-') then begin
                    if Deccolines.Used=true then
                      Error('This barcode has been shipped before');
                    Ship:=true;
                    Decommissioned:=true;
                    end else if not Deccolines.Find() then begin
                      Error('This barcode does not exist from list of decommisioned ATM items');
                      end;
                end;
                end;
                end;
                end else begin
                end;
            end;
        }
        field(16;Available;Boolean)
        {
            Editable = false;
        }
        field(17;"Error message";Text[100])
        {
        }
        field(18;"Part status";Option)
        {
            OptionCaption = 'Pending,Issued,Returned';
            OptionMembers = Pending,Issued,Returned;
        }
        field(19;Returned;Boolean)
        {
            Editable = false;
        }
        field(20;"bank abrr";Code[30])
        {
            TableRelation = "Bank Abbreviations"."abbr code";
        }
        field(21;Ship;Boolean)
        {

            trigger OnValidate()
            begin
                if COMPANYNAME='TECHNOLOGY ASSOCIATES EA LTD' then begin
                TestField(Barcode);
                  end;
            end;
        }
        field(22;Exist;Boolean)
        {
        }
        field(23;Return;Boolean)
        {

            trigger OnValidate()
            begin
                TestField("Part status","part status"::Issued);
            end;
        }
        field(24;"Case no";Code[20])
        {
        }
        field(25;"Atm Name";Text[100])
        {
        }
        field(26;"Is HDD";Boolean)
        {
        }
        field(27;"Req Date";Date)
        {
        }
        field(28;"issue date";Date)
        {
        }
        field(29;"Faulty Barcode";Code[10])
        {

            trigger OnValidate()
            begin
                
                 if "Faulty Barcode"<>'' then
                   /*
                   IF "Faulty Barcode"<>Barcode THEN BEGIN
                     IF "Faulty Barcode"<>'NULL' THEN
                     ERROR('Faulty Barcode can only be NULL or %1',Barcode);
                     END;
                     */
                if "Faulty Barcode"<>'NULL' then begin
                  barcodelenght:=StrLen("Faulty Barcode");
                  if barcodelenght<>4 then
                       Error('Barcode length must be 4 integers');
                
                Validatebar.Reset;
                Validatebar.SetRange(Validatebar.Barcode,"Faulty Barcode");
                Validatebar.SetRange(Validatebar."Part status",Validatebar."part status"::Issued);
                if Validatebar.Find('-') then begin
                
                  reqno:=Validatebar."Requestion No";
                  ObjAtmreg.Reset;
                  ObjAtmreg.SetRange(ObjAtmreg."Requestion No",Validatebar."Requestion No");
                  if ObjAtmreg.Find('-') then begin
                    atm1:=ObjAtmreg."ATM NO";
                    end;
                    ObjAtmreg.Reset;
                    ObjAtmreg.SetRange(ObjAtmreg."Requestion No",Barcode);
                    if ObjAtmreg.Find('-') then begin
                      atm2:=ObjAtmreg."ATM NO";
                
                      if atm1<>atm2 then
                
                      pendingline.Reset;
                  pendingline.SetRange(pendingline.Barcode,"Faulty Barcode");
                  pendingline.SetRange(pendingline."Part status",pendingline."part status"::Issued);
                  if pendingline.Find('-') then begin
                  reqno:=pendingline."Requestion No";
                  reqheaderpending.Reset;
                  reqheaderpending.SetRange(reqheaderpending."Requestion No",pendingline."Requestion No");
                  if reqheaderpending.Find('-') then begin
                  atm3:=reqheaderpending."ATM NO";
                  end;
                  if atm3<>atm2 then
                  Error("Faulty Barcode"+' was not previously issued to this ATM');
                  end;
                  end;
                  end;
                  end;
                

            end;
        }
        field(30;"faulty quantity";Integer)
        {
        }
        field(31;"Reason for Difference";Text[100])
        {
        }
        field(32;"Trc receive";Boolean)
        {
            Editable = true;
        }
        field(33;Repair;Boolean)
        {
        }
        field(34;"Repair Status";Option)
        {
            OptionCaption = ',faulty,Repaired,Beyond Repair';
            OptionMembers = ,faulty,Repaired,"Beyond Repair";
        }
        field(35;"quantity repaired";Integer)
        {
        }
        field(36;"quantity beyond repair";Integer)
        {
        }
        field(37;"Repaired by";Code[30])
        {
        }
        field(38;"Repaired on";Date)
        {
        }
        field(39;"Repair findings";Text[150])
        {
        }
        field(40;"Repair conclusion";Text[100])
        {
        }
        field(41;date;Date)
        {
        }
        field(42;"Report Date";Date)
        {
        }
        field(43;compulsory;Boolean)
        {
        }
        field(44;"Physical Location";Text[100])
        {

            trigger OnValidate()
            begin
                ObjAtmreg.Reset;
                ObjAtmreg.SetRange(ObjAtmreg."ATM NO","Atm No");
                if ObjAtmreg.Find('-') then
                  "Physical Location":=ObjAtmreg."Physical loation";
            end;
        }
        field(45;"ATM CodeN";Code[30])
        {
            TableRelation = "ATM Register."."ATM No";

            trigger OnValidate()
            begin
                if "ATM CodeN"<>'' then begin
                atmreg.Reset;
                atmreg.SetRange(atmreg."ATM No","ATM CodeN");
                if atmreg.Find('-') then begin
                  "ATM DescrN":=atmreg.Description;
                  "ATM SnN":=atmreg."Serial Number";

                end;
                end else if "ATM CodeN"='' then begin
                  "ATM DescrN":='';
                  "ATM SnN":='';

                end;
            end;
        }
        field(46;"ATM DescrN";Text[100])
        {
        }
        field(47;"ATM SnN";Code[50])
        {
        }
        field(48;Decommissioned;Boolean)
        {
        }
        field(49;"Decom Available";Text[50])
        {
        }
        field(50;"Get from Dec";Boolean)
        {
        }
        field(51;"Returned date";Date)
        {
            CalcFormula = lookup("Requisition Register"."Returned date" where ("Requestion No"=field("Requestion No")));
            FieldClass = FlowField;
        }
        field(52;"Serial No";Code[50])
        {
            TableRelation = "Decommisioned ATMs"."Serial No";

            trigger OnValidate()
            begin

                if "Get from Dec"=false then
                  Error('You must check Get From Decommissioned List');
                  Deccolines.Reset;
                  Deccolines.SetRange(Deccolines."Serial No","Serial No");
                  Deccolines.SetRange(Deccolines."Part No","Part No");
                  if Deccolines.Find('-') then begin
                    if Deccolines.Used=true then

                      Error("Part No"+ 'has already been used for Requisition No: '+ Deccolines."Requisition No");
                    end else if not Deccolines.Find() then begin
                      Deccolines.Init;
                      Deccolines."Serial No":="Serial No";
                      Deccolines."Part No":="Part No";
                      Deccolines.Quantity:=1;
                      Deccolines.Descr:=Description;
                      Deccolines.Insert;
                      Message("Part No"+ 'successfully added to '+"Serial No");

                end;
            end;
        }
        field(53;New;Boolean)
        {
        }
        field(54;Refurb;Boolean)
        {
        }
        field(55;"No. Printed";Integer)
        {
        }
        field(56;"Bank Updated";Boolean)
        {
        }
        field(57;"ATM No2";Code[20])
        {
            Description = 'Temporary ATM No.';
        }
        field(58;"New-Atm";Boolean)
        {
        }
        field(59;ReturnedBy;Code[40])
        {
        }
        field(60;"Time Returned";Time)
        {
        }
        field(61;"Eng Receipt";Boolean)
        {
        }
        field(62;"Date Engineer received";Date)
        {
        }
        field(63;"Recived By EngNo";Code[10])
        {
        }
        field(64;"Qty Received";Integer)
        {
        }
        field(65;"Engineer Comments";Text[50])
        {
        }
        field(66;"Issued To";Code[50])
        {
            CalcFormula = lookup("Requisition Register"."Issued To" where ("Requestion No"=field("Requestion No")));
            FieldClass = FlowField;
            //TableRelation = "HR-Employee"."Full Name" where("No."=field("Issued To"));
        }
    }

    keys
    {
        key(Key1;"Requestion No","Entry No","Part No",Barcode)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        ATMHRD: Record "ATM Hardware components";
        ObjAtmreg: Record "Requisition Register";
        Validatebar: Record "Component Line Register";
        atmreg: Record "ATM Register.";
        pendingline: Record "Component Line Register-Pendin";
        reqno: Code[10];
        atm1: Code[10];
        atm2: Code[10];
        atm3: Code[10];
        reqheaderpending: Record "Requisition Register-Pending";
        barcodelenght: Integer;
        reqreg: Record "Requisition Register-Pending";
        Deccolines: Record "Decommisioned ATMs Parts";
}

