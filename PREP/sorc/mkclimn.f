       parameter(jdum=2000)
       CHARACTER*200 grbdir,clmdir,expname
       CHARACTER*1  kdbug,kgau
       CHARACTER*10 ksyr,ksmth,ksday,kscy,knfdys
       CHARACTER*10 keyr,kemth,keday,kecy,kicy
       CHARACTER*10  kidim,kjdim,kkpds5,kkpds6,kkpds7
       CHARACTER*10  hgrid
c
       dimension deg(jdum), wt(jdum)
c
       call getenv("idbug",kdbug)
       read(kdbug,'(i1)') idbug
       write(*,*) "idbug= ",idbug
c
       call getenv("igau",kgau)
       read(kgau,'(i1)') igau
       write(*,*) "igau= ",igau
C
       call getenv("hgrid",hgrid)
       write(*,*) "hgrid= ",hgrid
       print *,'hgrid is ',hgrid

       call getenv("expname",expname)
       write(*,*) "expname= ",expname

       call getenv("grbdir",grbdir)
       write(*,*) "grbdir= ",grbdir

       call getenv("clmdir",clmdir)
       write(*,*) "clmdir= ",clmdir

       call getenv("syear",ksyr)
       read(ksyr,'(I4)') isyr
       write(*,*) "syear= ",isyr
C
       call getenv("smonth",ksmth)
       read(ksmth,'(I2)') ismth
       write(*,*) "smonth= ",ismth
C
       call getenv("sday",ksday)
       read(ksday,'(I2)') isday
       write(*,*) "sday= ",isday
C
       call getenv("shour",kscy)
       read(kscy,'(I2)') iscy
       write(*,*) "shour= ",iscy
C
       call getenv("eyear",keyr)
       read(keyr,'(I4)') ieyr
       write(*,*) "eyear= ",ieyr

       call getenv("emonth",kemth)
       read(kemth,'(I2)') iemth
       write(*,*) "emonth= ",iemth
C
       call getenv("eday",keday)
       read(keday,'(I2)') ieday
       write(*,*) "eday= ",ieday
C
       call getenv("ehour",kecy)
       read(kecy,'(I2)') iecy
       write(*,*) "ehour= ",iecy
c
       call getenv("idim",kidim)
       read(kidim,'(I10)') idim
       write(*,*) "idim= ",idim
c
       call getenv("jdim",kjdim)
       read(kjdim,'(I10)') jdim
       write(*,*) "jdim= ",jdim
c
       call getenv("kpds5",kkpds5)
       read(kkpds5,'(I3)') kpds5
       write(*,*) "kpds5= ",kpds5
c
       call getenv("kpds6",kkpds6)
       read(kkpds6,'(I3)') kpds6
       write(*,*) "kpds6= ",kpds6
c
       call getenv("kpds7",kkpds7)
       read(kkpds7,'(I3)') kpds7
       write(*,*) "kpds7= ",kpds7
c
       call getenv("nfdys",knfdys)
       read(knfdys,'(I2)') nfdys
       write(*,*) "nfdys= ",nfdys
c
       if(igau.eq.1) then
         call splat(4,jdim,deg,wt)
         pi    = 4.0 * atan(1.0)
         pifac = 180.0 / pi
         do j=1,jdim
           deg(j) = pifac * asin(deg(j))
         enddo
       else
         dlat = 180.0 / float(jdim-1)
         do j=1,jdim
           deg(j)=90.-float(j-1)*dlat
         enddo
       endif
c
       call avg(idim,jdim,grbdir,clmdir,nfdys,
     * isyr,ismth,isday,iscy,ieyr,iemth,ieday,iecy,
     * igau,idbug,deg,kpds5,kpds6,kpds7,hgrid,expname)
c
       stop
       end
       subroutine avg(idim,jdim,grbdir,clmdir,nfdys,
     * isyr,ismth,isday,iscy,ieyr,iemth,ieday,iecy,
     * igau,idbug,deg,kpds5,kpds6,kpds7,hgrid,expname)
c
       CHARACTER*200 grbdir,grbfile,indfile
       CHARACTER*200 clmdir,clmfile,expname
       CHARACTER*10  hgrid

       CHARACTER*4  LABY
       CHARACTER*2  LABM(12)
       CHARACTER*2  LABD(31)
       CHARACTER*2  LABC(0:23)

       real grid(idim,jdim),clim(idim,jdim)
       real annmean(idim,jdim,nfdys*4)
       real a(idim,jdim,nfdys*4,4),b(idim,jdim,nfdys*4,4)
       real deg(jdim)
c
       integer KPDS(200),KGDS(200)
       integer JPDS(200),JGDS(200)
       integer ncase(0:nfdys*4)
c
       logical*1 lbms(idim,jdim)
c
       DATA LABC/'00','01','02','03','04','05',
     &           '06','07','08','09','10','11',
     &           '12','13','14','15','16','17',
     &           '18','19','20','21','22','23'/
C
       DATA LABD/'01','02','03','04','05','06','07','08','09','10',
     *           '11','12','13','14','15','16','17','18','19','20',
     *           '21','22','23','24','25','26','27','28','29','30',
     *           '31'/
C
       DATA LABM/'01','02','03','04','05','06','07','08','09','10',
     *           '11','12'/
C
       ncns  = iw3jdn(isyr,ismth,isday)
       ncne  = iw3jdn(ieyr,iemth,ieday)


       PI=4.*ATAN(1.)
       period=365.24219
       OMEGA=2.0*PI/period

        nfhrs=nfdys*24
        ncys=0
        ncye=0
        icy=0

c... start cycle loop..
       print *,'LS GOING INTO CYCLE LOOP'
       print *,'LS', ncns,ncne

       do ncy=ncys,ncye,6
       annmean=0.
       ncase=0
C
c... start initial condition loop..
       print *,'LS GOING INTO IC LOOP'
       do ncn=ncns,ncne ! (Julian days range)
       call w3fs26(ncn,iyr,imth,iday,idaywk,idayyr)
       write(laby,'(i4)') iyr

       if ((iday.eq.1).or.(iday.eq.15)) then
C
        grbfile=grbdir(1:nfill(grbdir))//laby//labm(imth)//
     *  labd(iday)//'.grib'
        print *,grbfile
        call baopenr(11,grbfile,ierr)
        if(ierr.ne.0) then
         print *,'error opening file ',grbfile
         stop
        endif
        indfile=grbfile(1:nfill(grbfile)) // '.index'
        call baopenr(12,indfile,ierr)
        if(ierr.ne.0) then
         print *,'error opening file ',indfile
         stop
        endif

c... start forecast loop..
       print *,'LS GOING INTO FORECAST LOOP'
       do ifhr=6,nfhrs,6
       lead=ifhr/6
c
         do k=1,200
          JPDS(k) = -1
         enddo
         JPDS(5) = kpds5
         JPDS(6) = kpds6
         JPDS(7) = kpds7
         JPDS(8) = mod(IYR-1,100) + 1
         JPDS(9)  = IMTH
         JPDS(10) = IDAY
         JPDS(11) = ICY
         JPDS(14) = IFHR
         JPDS(21) = ((IYR-1)/100) + 1
         do k=1,200
          JGDS(k) = -1
         enddo
         N=-1
         CALL GETGB(11,12,idim*jdim,N,JPDS,JGDS,
     *              NDATA,KSKP,KPDS,KGDS,LBMS,GRID,IRET)
         if(iret.ne.0) then
          print *,' error in GETGB for rc = ',iret, jpds,grbfile
          stop
         endif
c 
         if(idbug.eq.1) then
          CALL GRIDAV(GRID,IDIM,JDIM,DEG,GLOB)
          print *,iyr,imth,iday,icy,ifhr,glob
         endif
       if (lead.gt.0)annmean(:,:,lead)=annmean(:,:,lead)+grid(:,:)
       if (lead.gt.0)ncase(lead)=ncase(lead)+1

c  end forecast loop
       enddo
       print *,'LS LEAVING FORECAST LOOP'
        call baclose(11,ierr)
        if(ierr.ne.0) then
         print *,'error closing file ',grbfile
         stop
        endif
        call baclose(12,ierr)
        if(ierr.ne.0) then
         print *,'error closing file ',indfile
         stop
        endif

       endif

c  end initial condition loop
       enddo
       print *,'LS LEAVING IC LOOP'
c
       do lead=1,nfdys*4
        annmean(:,:,lead)=annmean(:,:,lead)/float(ncase(lead))
        grid(:,:)=annmean(:,:,lead)
c       write(21)grid
        print *,lead,ncase(lead),grid(290,56)
       enddo

c  end cycle loop
       enddo
       print *,'LS LEAVING CYCLE LOOP'
c
       print *,'LS',ncys,ncye,ncns,ncne,iyr,imth,iday,idaywk,idayyr
c----2nd cycle loop to estimate the a's and b's
       do ncy=ncys,ncye,6

       print *,'LS ENTERING 2nd CYCLE LOOP'
       print *,'LS',ncys,ncye,ncns,ncne,iyr,imth,iday,idaywk,idayyr
       a=0.
       b=0.
       ncase=0
       nd=0

       print *,'LS ABOUT TO ENTER 2nd IC LOOP'
c... start initial condition loop..

c       print *,'LS ncns and ncne',ncns,ncne
       print *,'LS',ncys,ncye,ncns,ncne,iyr,imth,iday,idaywk,idayyr
       do ncn=ncns,ncne ! (Julian days range)
       print *,'ENTERED 2nd IC LOOP'

       nd=nd+1
       call w3fs26(ncn,iyr,imth,iday,idaywk,idayyr)
       write(laby,'(i4)') iyr

       if ((iday.eq.1).or.(iday.eq.15)) then
c
        print *,grbfile
        grbfile=grbdir(1:nfill(grbdir))//laby//labm(imth)//
     *  labd(iday)//'.grib'
        call baopenr(11,grbfile,ierr)
        if(ierr.ne.0) then
         print *,'error opening file ',grbfile
         stop
        endif
        indfile=grbfile(1:nfill(grbfile)) // '.index'
        call baopenr(12,indfile,ierr)
        if(ierr.ne.0) then
         print *,'error opening file ',indfile
         stop
        endif
              
c... start forecast loop..
       do ifhr=6,nfhrs,6
       print *,'ENTERING 2nd FCST LOOP'
       lead=ifhr/6
c
         do k=1,200
          JPDS(k) = -1
         enddo
         JPDS(5) = kpds5
         JPDS(6) = kpds6
         JPDS(7) = kpds7
         JPDS(8) = mod(IYR-1,100) + 1
         JPDS(9)  = IMTH
         JPDS(10) = IDAY
         JPDS(11) = ICY
c        JPDS(13) = 1
         JPDS(14) = IFHR
         JPDS(21) = ((IYR-1)/100) + 1
         do k=1,200
          JGDS(k) = -1
         enddo
         N=-1
         CALL GETGB(11,12,idim*jdim,N,JPDS,JGDS,
     *              NDATA,KSKP,KPDS,KGDS,LBMS,GRID,IRET)
         if(iret.ne.0) then
          print *,' error in GETGB for rc = ',iret, jpds,grbfile
          stop
         endif
c
         if(idbug.eq.1) then
          CALL GRIDAV(GRID,IDIM,JDIM,DEG,GLOB)
          print *,iyr,imth,iday,icy,ifhr,glob
         endif
c
         if (lead.gt.0)then
          grid(:,:)=grid(:,:)-annmean(:,:,lead)
          do itone=1,4  ! 4 is a choice
           ANGLE = FLOAT(nd) * OMEGA*float(itone)
           FAKC = COS(ANGLE)
           FAKs = SIN(ANGLE)
           a(:,:,lead,itone)=a(:,:,lead,itone)+grid(:,:)*faks
           b(:,:,lead,itone)=b(:,:,lead,itone)+grid(:,:)*fakc
          enddo
          ncase(lead)=ncase(lead)+1
         endif
c
c  end forecast loop
       enddo

        call baclose(11,ierr)
        if(ierr.ne.0) then
         print *,'error closing file ',grbfile
         stop
        endif
        call baclose(12,ierr)
        if(ierr.ne.0) then
         print *,'error closing file ',indfile
         stop
        endif

       endif

c  end initial condition loop
       enddo
c
       do lead=1,nfdys*4
        a(:,:,lead,:)=2.*a(:,:,lead,:)/float(ncase(lead))
        b(:,:,lead,:)=2.*b(:,:,lead,:)/float(ncase(lead))
        print *,lead,ncase(lead),a(290,56,lead,1),b(290,56,lead,1)
       enddo

c  end cycle loop
       enddo
       print *,'EXITING 2nd CYCLE LOOP'

c.. now write out the climos..

         iyrc=2012
         ismthc=1
         isdayc=1
         iemthc=12
         iedayc=31

         icyc=0
         ncnsc  = iw3jdn(iyrc,ismthc,isdayc)
         ncnec  = iw3jdn(iyrc,iemthc,iedayc)

         kpdsx=kpds(22)+2
         do ncnc=ncnsc,ncnec ! (set the 366 Julian days range for generic year 2012) initial times
          call w3fs26(ncnc,iyrc,imthc,idayc,idaywk,idayyr)

          if((idayc.eq.1).or.(idayc.eq.15))then

c          /climate/noscrub/emc.climpara/Suru/validation/climatology/UGCSbench_mom6/z500/z500.
c          12.15.00Z.mean.clim.daily.1x1.UGCSbench_mom6
c          OR
c          /climate/noscrub/emc.climpara/Suru/validation/climatology/UGCSbench_mom6/PRATEsfc/T126/PRATEsfc.
c          12.15.00Z.mean.clim.daily.T126.UGCSbench_mom6

           clmfile=clmdir(1:nfill(clmdir))//labm(imthc)//'.'//
     *     labd(idayc)//'.'//labc(icyc)//'Z.mean.clim.daily.'//
     *     hgrid(1:nfill(hgrid))//'.'//expname(1:nfill(expname))


           print *,'clmfile ',clmfile
           call baopenwt(71,clmfile,ierr)
           if(ierr.ne.0) then
            print *,'error opening file ',clmfile
            stop
           endif

           lead=0
           do id=1,nfdys*4
            lead=lead+1
            ifhr=lead*6
            call recoclimo(annmean,a,b,lead,clim,idim,jdim,ncnc,nfdys)
            KPDS(8) = mod(iyrc-1,100) + 1
            KPDS(9)  = imthc
            KPDS(10) = idayc
            KPDS(11) = icyc
            KPDS(14) = IFHR
            KPDS(22) = kpdsx
            KPDS(21) = ((iyrc-1)/100) + 1
            CALL PUTGB(71,NDATA,KPDS,KGDS,LBMS,clim,IRET)
            if(iret.ne.0) then
             print *,nr,' error in PUTGB for iret ',iret
             stop
            endif
            call gridav(clim,idim,jdim,deg,ggrid)
            print *,iyrc,imthc,idayc,icyc,ifhr,ggrid
           enddo
           call baclose(71,ierr)
           if(ierr.ne.0) then
            print *,'error closing file ',clmfile
            stop
           endif
c
          endif

         enddo
c
       print*,"I AM DONE in mkclimn"
       return
       end
c
      subroutine recoclimo(annmean,a,b,lead,clim,idim,jdim,ncn,nfdys)
      real clim(idim,jdim),annmean(idim,jdim,nfdys*4)
       real a(idim,jdim,nfdys*4,4),b(idim,jdim,nfdys*4,4)
      nd=ncn-2455653+1! we take apr 1 2011 as nd=1. 
       PI=4.*ATAN(1.)
       period=365.24219
       OMEGA=2.0*PI/period
       clim(:,:)=annmean(:,:,lead)
       do itone=1,4
       ANGLE = FLOAT(nd) * OMEGA*float(itone)
       FAKC = COS(ANGLE)
       FAKs = SIN(ANGLE)
       clim(:,:)=clim(:,:)
     *   +a(:,:,lead,itone)*faks+b(:,:,lead,itone)*fakc
       enddo
c
      return
      end
