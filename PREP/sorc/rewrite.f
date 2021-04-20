       parameter(jdum=2000)
       CHARACTER*200 grbdir,outdir
       CHARACTER*1  kdbug,kgau
       CHARACTER*10 ksyr,ksmth,ksday,kscy,knfdys
       CHARACTER*10 keyr,kemth,keday,kecy,kicy,kfactor
       CHARACTER*10 kidim,kjdim,kkpds5,kkpds6,kkpds7
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
       call getenv("grbdir",grbdir)
       write(*,*) "grbdir= ",grbdir

       call getenv("outdir",outdir)
       write(*,*) "outdir= ",outdir

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
       call getenv("factor",kfactor)
       read(kfactor,'(F10.2)') factor
       write(*,*) "factor= ",factor
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
       call avg(idim,jdim,grbdir,outdir,nfdys,
     * isyr,ismth,isday,iscy,ieyr,iemth,ieday,iecy,
     * igau,idbug,deg,kpds5,kpds6,kpds7,factor)
c
       stop
       end
       subroutine avg(idim,jdim,grbdir,outdir,nfdys,
     * isyr,ismth,isday,iscy,ieyr,iemth,ieday,iecy,
     * igau,idbug,deg,kpds5,kpds6,kpds7,factor)
c
       CHARACTER*200 grbdir,grbfile,indfile
       CHARACTER*200 outdir,grbout
       CHARACTER*4  LABY
       CHARACTER*2  LABM(12)
       CHARACTER*2  LABD(31)
       CHARACTER*2  LABC(0:23)

       real grid(idim,jdim)
       real deg(jdim)
c
       integer KPDS(200),KGDS(200)
       integer JPDS(200),JGDS(200)
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
       nstat=ncne-ncns+1 ! NCNS is starting Julian day number

       PI=4.*ATAN(1.)
       period=365.24219
       OMEGA=2.0*PI/period
        ncys=6

        nfhrs=nfdys*24

c... start initial condition loop..
       do ncn=ncns,ncne ! (Julian days range)
       call w3fs26(ncn,iyr,imth,iday,idaywk,idayyr)
       write(laby,'(i4)') iyr

       if((iday.eq.1).or.(iday.eq.15)) then
c
        grbfile=grbdir(1:nfill(grbdir))//laby//labm(imth)//
     *  labd(iday)//'.grib'
        write(*,*) "grbfile= ",grbfile
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
        grbout=outdir(1:nfill(outdir))//laby//labm(imth)//
     *  labd(iday)//'.grib'
        write(*,*) "grbout= ",grbout
        call baopenwt(71,grbout,ierr)
        if(ierr.ne.0) then
         print *,'error opening file ',grbout
         stop
        endif

c... start forecast loop..
        N=-1
       do ifhr=6,nfhrs,6
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
c        JPDS(14) = IFHR
         JPDS(21) = ((IYR-1)/100) + 1
         do k=1,200
          JGDS(k) = -1
         enddo
         N=N+1
         CALL GETGB(11,12,idim*jdim,N,JPDS,JGDS,
     *              NDATA,KSKP,KPDS,KGDS,LBMS,GRID,IRET)
         if(iret.ne.0) then
          print *,N,' error in GETGB for rc = ',iret, jpds
          stop
         endif
c
         if(idbug.eq.1) then
          CALL GRIDAV(GRID,IDIM,JDIM,DEG,GLOB)
          print 411,N,iyr,imth,iday,icy,ifhr,glob*factor,
     *    grid(750,350)*factor
         endif
c
         KPDS(14) = IFHR
         KPDS(16) = 10
         CALL PUTGB(71,NDATA,KPDS,KGDS,LBMS,GRID,IRET)
         if(iret.ne.0) then
          print *,N,' error in PUTGB for iret ',iret
          stop
         endif
c
c  end forecast loop
       enddo

        print *,'closing old files'
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
        call baclose(71,ierr)
        if(ierr.ne.0) then
         print *,'error closing file ',grbout
         stop
        endif

       endif

c  end initial condition loop
       enddo

 411   format(1x,6I8,2x,2F10.2)
       return
       end
