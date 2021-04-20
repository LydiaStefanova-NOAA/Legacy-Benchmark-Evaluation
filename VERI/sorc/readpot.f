       parameter(jdum=2000,nlev=26)
       CHARACTER*200 cfsrdir,clmcfsr
       CHARACTER*200 expdir,clmexp,plotdatadir
       CHARACTER*200 expname,varname
       CHARACTER*200 maskfile
       CHARACTER*1  kdbug,kgau
       CHARACTER*10 ksyr,ksmth,ksday,kscy,knfdys
       CHARACTER*10 keyr,kemth,keday,kecy,kicy
       CHARACTER*10 kidim,kjdim,kkpds5,kkpds6
c
       dimension deg(jdum), wt(jdum)
c
       integer ipotlev(nlev)
c
c      data ipotlev/303,262,238,225,215,205,195,185,175,165,155,145,
c    *              135,125,115,105,95,85,75,65,55,45,35,25,15,5/
       data ipotlev/5,15,25,35,45,55,65,75,85,95,105,115,125,135,
     *              145,155,165,175,185,195,205,215,225,238,262,303/

       call getenv("idbug",kdbug)
       read(kdbug,'(i1)') idbug
       write(*,*) "idbug= ",idbug
c
       call getenv("igau",kgau)
       read(kgau,'(i1)') igau
       write(*,*) "igau= ",igau
C
       call getenv("expname",expname)
       write(*,*) "expname= ",expname
C
       call getenv("maskfile",maskfile)
       write(*,*) "maskfile= ",maskfile
C
       call getenv("var",varname)
       write(*,*) "varname= ",varname
C
       call getenv("plotdatadir",plotdatadir)
       write(*,*) "plotdatadir= ",plotdatadir
C
       call getenv("cfsrdir",cfsrdir)
       write(*,*) "cfsrdir= ",cfsrdir

       call getenv("clmcfsr",clmcfsr)
       write(*,*) "clmcfsr= ",clmcfsr

       call getenv("expdir",expdir)
       write(*,*) "expdir= ",expdir

       call getenv("clmexp",clmexp)
       write(*,*) "clmexp= ",clmexp

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
       call avg(idim,jdim,cfsrdir,clmcfsr,
     * expdir,clmexp,expname,varname,plotdatadir,maskfile,
     * isyr,ismth,isday,iscy,ieyr,iemth,ieday,iecy,
     * igau,idbug,deg,kpds5,kpds6,nfdys,nlev,ipotlev)
c
       stop
       end
       subroutine avg(idim,jdim,cfsrdir,clmcfsr,
     * expdir,clmexp,expname,varname,plotdatadir,maskfile,
     * isyr,ismth,isday,iscy,ieyr,iemth,ieday,iecy,
     * igau,idbug,deg,kpds5,kpds6,nfdys,nlev,ipotlev)
c
       parameter(nbox=4)
       CHARACTER*200 expname,rname,pname,varname
       CHARACTER*200 cfsrdir,clmcfsr
       CHARACTER*200 expdir,clmexp,plotdatadir
       CHARACTER*200 maskfile
       CHARACTER*200 cfsrgrb,cfsrind,cfsrclm,cfsrclmind
       CHARACTER*200 expgrb,expind,expclm,expclmind
       CHARACTER*200 clmdir,clmfile

       CHARACTER*4  LABY
       CHARACTER*2  LABM(12)
       CHARACTER*2  LABD(31)
       CHARACTER*2  LABC(0:23)

       real gridv(idim,jdim),climv(idim,jdim)
       real gridc(idim,jdim),climc(idim,jdim)
       real gridu(idim,jdim),climu(idim,jdim)

       real grid(idim,jdim),gridm(idim,jdim)

       real acloco(idim,jdim)
       real anom(idim,jdim),anom1(idim,jdim)
       real anomsec(idim,jdim)

       real deg(jdim),cosl(jdim),rinc(5)
       dimension wt(2000)

c* 144 cases (twice a month for 6 years), 6 spheres+boxes, 140 6hr leads
      dimension rms(144,6,140,nlev),sx1(144,6,140,nlev),
     *          sy1(144,6,140,nlev),cv(144,6,140,nlev)
      dimension crms(144,6,140,nlev),csx1(144,6,140,nlev),
     *          csy1(144,6,140,nlev),ccv(144,6,140,nlev)

      real*4 save(idim,jdim,144,115,nlev)
      real*4 savesec(idim,jdim,144,115,nlev)
      real*4 savever(idim,jdim,144,115,nlev)
      real*4 acts(144,nlev),cacts(144,nlev),res(16,nlev),cres(16,nlev)

       integer isbox(4),iebox(4)
       integer jsbox(4),jebox(4)
       integer lds(5),lde(5)
       integer idate(8),jdate(8)
c
       integer KPDS(200),KGDS(200)
       integer JPDS(200),JGDS(200)
c
       integer ipotlev(nlev)

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
      if(igau.eq.1) then
         call splat(4,jdim,deg,wt)
         pi    = 4.0 * atan(1.0)
         pifac = 180.0 / pi
         do j=1,jdim
           deg(j) = pifac * asin(deg(j))
           cosl(j)=wt(j)! for weighting inside ac(
         enddo
       else
      pi=4.*atan(1.)
      CONV=PI/180.
         dlat = 180.0 / float(jdim-1)
      DO j=1,jdim
         ALAT=90.-FLOAT(j-1)*dlat
         cosl(j)=COS(ALAT*CONV)
      END DO
      endif
c
      lds(1)=1
      lde(1)=27!wk1
      lds(2)=28
      lde(2)=55!wk2
      lds(3)=56
      lde(3)=83!wk3
      lds(4)=84
      lde(4)=111!wk4
      lds(5)=56
      lde(5)=111!wk3&4
c... NH (80N-20N)
       isbox(1)=1
       iebox(1)=idim
       jsbox(1)=11
       jebox(1)=70

c... TR (20N-20S)
       isbox(2)=1
       iebox(2)=idim
       jsbox(2)=71
       jebox(2)=111

c... SH (20S-80S)
       isbox(3)=1
       iebox(3)=idim
       jsbox(3)=112
       jebox(3)=171

c... GL (90N-90S)
       isbox(4)=1
       iebox(4)=idim
       jsbox(4)=1
       jebox(4)=jdim
c
       ncns  = iw3jdn(isyr,ismth,isday)
       ncne  = iw3jdn(ieyr,iemth,ieday)

       nfhrs=nfdys*24
       iyrc=2012
       icase=0
c
c..... read mask..
       print *,maskfile
       call baopenr(10,maskfile,ierr)
       if(ierr.ne.0) then
        print *,'error opening file ',maskfile
        stop
       endif
       do k=1,200
        JPDS(k) = -1
        enddo
       JPDS(5) = 81
       JPDS(6) = 1
       JPDS(7) = 0
       do k=1,200
        JGDS(k) = -1
       enddo
       N=-1
       CALL GETGB(10,0,idim*jdim,N,JPDS,JGDS,
     *            NDATA,KSKP,KPDS,KGDS,LBMS,GRIDM,IRET)
       if(iret.ne.0) then
        print *,' error in GETGB for rc = ',iret, jpds
        print *,' maskfile = ',maskfile
        stop
       endif
       if(idbug.eq.1) then
        print *,gridm(10,10),gridm(100,100),gridm(200,100)
       endif
       do j=44,69
       write(6,777)(nint(gridm(i,j)),i=246,321)
       enddo
777    format(100i1)
c... start cycle loop..
       do ncy=ncys,ncye,6

       nd=0
c... start initial condition loop..
       do ncn=ncns,ncne ! (Julian days range)
       nd=nd+1

       call w3fs26(ncn,iyr,imth,iday,idaywk,idayyr)
       write(laby,'(i4)') iyr

      if ((iday.eq.1).or.(iday.eq.15)) then

      icase=icase+1
c..  open cfsr climo file
       cfsrclm=clmcfsr(1:nfill(clmcfsr))//labm(imth)//'.'//labd(iday)//
     * '.00Z.mean.clim.daily.1x1.CFSR'
c      print *,cfsrclm
       call baopenr(11,cfsrclm,ierr)
       if(ierr.ne.0) then
        print *,'error opening file ',cfsrclm
        stop
       endif
       cfsrclmind=cfsrclm(1:nfill(cfsrclm))//'.index'
c      print *,cfsrclmind
       call baopenr(12,cfsrclmind,ierr)
       if(ierr.ne.0) then
        print *,'error opening file ',cfsrclmind
        stop
       endif
c..  open exp climo file
       expclm=clmexp(1:nfill(clmexp))//labm(imth)//'.'//labd(iday)//
     * '.00Z.mean.clim.daily.1x1.'//expname(1:nfill(expname))
c      print *,expclm
       call baopenr(15,expclm,ierr)
       if(ierr.ne.0) then
        print *,'error opening file ',expclm
        stop
       endif
       expclmind=expclm(1:nfill(expclm))//'.index'
c      print *,expclmind
       call baopenr(16,expclmind,ierr)
       if(ierr.ne.0) then
        print *,'error opening file ',expclmind
        stop
       endif

c..  open cfsr data file
        cfsrgrb=cfsrdir(1:nfill(cfsrdir))//laby//labm(imth)//
     *  labd(iday)//'.grib'
c       print *,cfsrgrb
        call baopenr(21,cfsrgrb,ierr)
        if(ierr.ne.0) then
         print *,'error opening file ',cfsrgrb
         stop
        endif
        cfsrind=cfsrgrb(1:nfill(cfsrgrb))//'.index'
c       print *,cfsrind
        call baopenr(22,cfsrind,ierr)
        if(ierr.ne.0) then
         print *,'error opening file ',cfsrind
         stop
        endif
c..  open exp data file
        expgrb=expdir(1:nfill(expdir))//laby//labm(imth)//
     *  labd(iday)//'.grib'
c       print *,expgrb
        call baopenr(25,expgrb,ierr)
        if(ierr.ne.0) then
         print *,'error opening file ',expgrb
         stop
        endif
        expind=expgrb(1:nfill(expgrb))//'.index'
c       print *,expind
        call baopenr(26,expind,ierr)
        if(ierr.ne.0) then
         print *,'error opening file ',expind
         stop
        endif

c...start level loop
        do ilev=1,nlev
         kpds7=ipotlev(ilev)

c... start forecast loop..
       do ifhr=6,nfhrs,6
        lead=ifhr/6

         do k=1,200
          JPDS(k) = -1
         enddo
         JPDS(5) = kpds5
         JPDS(6) = kpds6
         JPDS(7) = kpds7
         JPDS(9)  = imth
         JPDS(10) = iday
         JPDS(11) = icy
         JPDS(14) = ifhr
         JPDS(21) = ((iyr-1)/100) + 1
         do k=1,200
          JGDS(k) = -1
         enddo

          JPDS(8) = mod(iyrc-1,100) + 1
c... get cfsr climo..
          N=-1
          CALL GETGB(11,12,idim*jdim,N,JPDS,JGDS,
     *               NDATA,KSKP,KPDS,KGDS,LBMS,CLIMV,IRET)
          if(iret.ne.0) then
           print *,' error in GETGB for rc = ',iret, jpds
           print *,' cfsrclm = ',cfsrclm
           stop
          endif
c... get exp climo..
          N=-1
          CALL GETGB(15,16,idim*jdim,N,JPDS,JGDS,
     *               NDATA,KSKP,KPDS,KGDS,LBMS,CLIMU,IRET)
          if(iret.ne.0) then
           print *,' error in GETGB for rc = ',iret, jpds
           print *,' expclm = ',expclm
           stop
          endif

c... exp data..
         do k=1,200
          JPDS(k) = -1
         enddo
         JPDS(5) = kpds5
         JPDS(6) = kpds6
         JPDS(7) = kpds7
c        JPDS(8) = mod(iyr-1,100) + 1
c        JPDS(9)  = imth
c        JPDS(10) = iday
c        JPDS(11) = icy
         JPDS(14) = ifhr
c        JPDS(21) = ((iyr-1)/100) + 1
         do k=1,200
          JGDS(k) = -1
         enddo

          N=-1
          CALL GETGB(25,26,idim*jdim,N,JPDS,JGDS,
     *               NDATA,KSKP,KPDS,KGDS,LBMS,GRIDU,IRET)
          if(iret.ne.0) then
           print *,' error in GETGB for rc = ',iret, jpds
           print *,' expgrb = ',expgrb
           stop
          endif
c
c... get cfsr data..
          jdate=0
          jdate(1)=iyr
          jdate(2)=imth
          jdate(3)=iday
          jdate(5)=ncy
          rinc=0.
          rinc(2)=float(ifhr)
          idate=0
          call w3movdat(rinc,jdate,idate)
          iyrv=idate(1)
          imthv=idate(2)
          idayv=idate(3)
          icyv=idate(5)

c       print *,kpds7,iyr,imth,iday,ncy,iyrv,imthv,idayv,icyv,ifhr
c
          do k=1,200
           JPDS(k) = -1
          enddo
          JPDS(5) = kpds5
          JPDS(6) = kpds6
          JPDS(7) = kpds7
          JPDS(8) = mod(iyrv-1,100) + 1
          JPDS(9)  = imthv
          JPDS(10) = idayv
          JPDS(11) = icyv
          JPDS(21) = ((iyrv-1)/100) + 1
          do k=1,200
           JGDS(k) = -1
          enddo
          N=-1
          CALL GETGB(21,22,idim*jdim,N,JPDS,JGDS,
     *               NDATA,KSKP,KPDS,KGDS,LBMS,GRIDV,IRET)
          if(iret.ne.0) then
           print *,' error in GETGB for rc = ',iret, jpds
           print *,' cfsrgrb = ',cfsrgrb
           stop
          endif
          CALL GRIDAV(CLIMV,IDIM,JDIM,DEG,GCLIMV)
          CALL GRIDAV(CLIMU,IDIM,JDIM,DEG,GCLIMU)
          CALL GRIDAV(GRIDV,IDIM,JDIM,DEG,GGRIDV)
          CALL GRIDAV(GRIDU,IDIM,JDIM,DEG,GGRIDU)
          print 111,iyr,imth,iday,icase,lead,gclimv,gclimu,
     *    ggridv,ggridu

c* clim is climatologies, grid are frcst or verification
c* v=verification,u=experiment(exp)
          anom1=gridv-climv
          anom=gridu-climv!exp raw
          anomsec=gridu-climu!exp SEC
          if (lead.le.115)save(:,:,icase,lead,ilev)=anom(:,:)
          if (lead.le.115)savever(:,:,icase,lead,ilev)=anom1(:,:)
          if (lead.le.115)savesec(:,:,icase,lead,ilev)=anomsec(:,:)
c* 1,70=NH; 71,111=TR; 112,181=SH for 1x1 grid
          do ib=1,3! here ib is also ihemi
          is=isbox(ib)
          ie=iebox(ib)
          js=jsbox(ib)
          je=jebox(ib)
          x=ac(anom,anom1,cosl,idim,jdim,1.,is,ie,js,je,
     *cov,sx,sy,r,lead,kpds7,gridm)
          rms(icase,ib,lead,ilev)=r
          sx1(icase,ib,lead,ilev)=sx
          sy1(icase,ib,lead,ilev)=sy
          cv(icase,ib,lead,ilev)=cov
          x=ac(anomsec,anom1,cosl,idim,jdim,1.,is,ie,js,je,
     *cov,sx,sy,r,lead,kpds7,gridm)
          crms(icase,ib,lead,ilev)=r
          csx1(icase,ib,lead,ilev)=sx
          csy1(icase,ib,lead,ilev)=sy
          ccv(icase,ib,lead,ilev)=cov
       enddo! ib(ox) loop

c  end forecast loop
       enddo

c  end level loop
       enddo

        call baclose(11,ierr)
        if(ierr.ne.0) then
         print *,'error closing file ',cfsrclm
         stop
        endif
        call baclose(12,ierr)
        if(ierr.ne.0) then
         print *,'error closing file ',cfsrclmind
         stop
        endif
        call baclose(15,ierr)
        if(ierr.ne.0) then
         print *,'error closing file ',expclm
         stop
        endif
        call baclose(16,ierr)
        if(ierr.ne.0) then
         print *,'error closing file ',expclmind
         stop
        endif

        call baclose(21,ierr)
        if(ierr.ne.0) then
         print *,'error closing file ',cfsrgrb
         stop
        endif
        call baclose(22,ierr)
        if(ierr.ne.0) then
         print *,'error closing file ',cfsrind
         stop
        endif
        call baclose(25,ierr)
        if(ierr.ne.0) then
         print *,'error closing file ',expgrb
         stop
        endif
        call baclose(26,ierr)
        if(ierr.ne.0) then
         print *,'error closing file ',expind
         stop
        endif
       endif

c  end initial condition loop
       enddo
c
c  end cycle loop
       enddo
c
c.. start level-loop
      do ilev=1,nlev
      kpds7=ipotlev(ilev)

      do ihemi=1,3!NH,TR,SH
C     determine file name properties
      SELECT CASE (ihemi)
        CASE (1)
          rname='NH'
        CASE (2)
          rname='TR'
        CASE (3)
          rname='SH'
        CASE DEFAULT
          PRINT *,'Unknown case. Stop.'
          EXIT
      END SELECT
C     open file to write
      OPEN(UNIT=12,FILE=plotdatadir(1:NFILL(plotdatadir))
     * //'/'//expname(1:NFILL(expname))
     * //'.'//varname(1:NFILL(varname))
     * //'.'//rname(1:NFILL(rname))//'.dieoff.daily.txt')
      do lead=4,140,4
      call talley(rms,sx1,sy1,cv,lead,ilev,ihemi
     *,res1,res2,res3,res4,res5)
      call talley(crms,csx1,csy1,ccv,lead,ilev,ihemi
     *,cres1,cres2,cres3,cres4,cres5)
       print 112,res1,res2,res3,res5,float(lead)/4.,kpds7,
     *cres1,cres2,cres3,cres5,ihemi
C     write to file
      WRITE(12,112),res1,res2,res3,res5,float(lead)/4.,kpds7,
     *cres1,cres2,cres3,cres5,ihemi
       enddo
       print 112
C     close file
      CLOSE(12)
      enddo 

      do ihemi=1,3!NH,TR,SH
C     determine file name properties
      SELECT CASE (ihemi)
        CASE (1)
          rname='NH'
        CASE (2)
          rname='TR'
        CASE (3)
          rname='SH'
        CASE DEFAULT
          PRINT *,'Unknown case. Stop.'
          EXIT
      END SELECT
C     open file to write
      OPEN(UNIT=12,FILE=plotdatadir(1:NFILL(plotdatadir))
     * //'/'//expname(1:NFILL(expname))
     * //'.'//varname(1:NFILL(varname))
     * //'.'//rname(1:NFILL(rname))//'.dieoff.6hrly.txt')
       do lead=1,140
      call talley(rms,sx1,sy1,cv,lead,ilev,ihemi
     *,res1,res2,res3,res4,res5)
      call talley(crms,csx1,csy1,ccv,lead,ilev,ihemi
     *,cres1,cres2,cres3,cres4,cres5)
       print 112,res1,res2,res3,res5,float(lead)/4.,kpds7,
     *cres1,cres2,cres3,cres5,ihemi
C     write to file
      WRITE(12,112),res1,res2,res3,res5,float(lead)/4.,kpds7,
     *cres1,cres2,cres3,cres5,ihemi
       enddo
       print 112
C     close file
      CLOSE(12)
      enddo
c
          do ib=1,3! here ib is also ihemi
          is=isbox(ib)
          ie=iebox(ib)
          js=jsbox(ib)
          je=jebox(ib)
      do iw=1,5! wk1, 2, 3, 4, and 3&4
      fakave=float(lde(iw)-lds(iw)+1)
      do icase=1,144
       anom=0.
       anom1=0.
        do lead=lds(iw),lde(iw)
        grid(:,:)=save(:,:,icase,lead,ilev)
        anom=anom+grid/fakave
        grid(:,:)=savever(:,:,icase,lead,ilev)
        anom1=anom1+grid/fakave
        enddo
          x=ac(anom,anom1,cosl,idim,jdim,1.,is,ie,js,je,
     *    cov,sx,sy,r,lead,kpds7,gridm)
      if (iw.eq.5.and.ib.eq.1)acts(icase,ilev)=x*100.
          rms(icase,ib,iw,ilev)=r
          sx1(icase,ib,iw,ilev)=sx
          sy1(icase,ib,iw,ilev)=sy
          cv(icase,ib,iw,ilev)=cov
       anom=0.
        do lead=lds(iw),lde(iw)
        grid(:,:)=savesec(:,:,icase,lead,ilev)
        anom=anom+grid/fakave
        enddo
          x=ac(anom,anom1,cosl,idim,jdim,1.,is,ie,js,je,
     *    cov,sx,sy,r,lead,kpds7,gridm)
      if (iw.eq.5.and.ib.eq.1)cacts(icase,ilev)=x*100.
          crms(icase,ib,iw,ilev)=r
          csx1(icase,ib,iw,ilev)=sx
          csy1(icase,ib,iw,ilev)=sy
          ccv(icase,ib,iw,ilev)=cov
      enddo
      enddo! iw(eek) loop
      enddo! ib(ox) loop
c* wk1
      write(6,727)
727   format(1h ,'wk1 ')
c* wk2
      write(6,728)
728   format(1h ,'wk2 ')
c* wk3
      write(6,729)
729   format(1h ,'wk3 ')
c* wk4
      write(6,730)
730   format(1h ,'wk4 ')
      write(6,731)
731   format(1h ,'wk3&4 ')
c
      do ihemi=1,3!NH
       do lead=1,5
       ib=ihemi
       SELECT CASE (ib)
        CASE (1)
          rname='NH'
        CASE (2)
          rname='TR'
        CASE (3)
          rname='SH'
        CASE DEFAULT
          PRINT *,'Unknown case. Stop.'
          EXIT
       END SELECT
C     open file to write
      OPEN(UNIT=12,FILE=plotdatadir(1:NFILL(plotdatadir))
     * //'/'//expname(1:NFILL(expname))
     * //'.'//varname(1:NFILL(varname))
     * //'.'//rname(1:NFILL(rname))//
     * '.dieoff.average.txt')
      call talley(rms,sx1,sy1,cv,lead,ilev,ihemi
     *,res1,res2,res3,res4,res5)
      call talley(crms,csx1,csy1,ccv,lead,ilev,ihemi
     *,cres1,cres2,cres3,cres4,cres5)
       print 112,res1,res2,res3,res5,float(lead),kpds7,
     *cres1,cres2,cres3,cres5,ihemi
C     write to file
      WRITE(12,112),res1,res2,res3,res5,float(lead),kpds7,
     *cres1,cres2,cres3,cres5,ihemi
       enddo
C     close file
      CLOSE(12)
       print 112
      enddo

       write(6,732)
       write(6,732)(acts(icase,ilev),icase=1,144)
       write(6,732)
       write(6,732)(cacts(icase,ilev),icase=1,144)
      do in=1,24
      ave=0.
      cave=0.
      do idum=in,144,24
      ave=ave+acts(idum,ilev)
      cave=cave+cacts(idum,ilev)
      enddo
      acts(in,ilev)=ave/6.
      cacts(in,ilev)=cave/6.
      enddo
       write(6,732)
       write(6,732)(acts(in,ilev),in=1,24)
       write(6,732)
       write(6,732)(cacts(in,ilev),in=1,24)
       write(6,732)
       write(6,732)((acts(in,ilev)+acts(in+1,ilev))/2.,in=1,24,2)
       write(6,732)((cacts(in,ilev)+cacts(in+1,ilev))/2.,in=1,24,2)
c
      write(6,731)
       im=3
       do in=1,24,2
       im=im+1
       res(im,ilev)=(acts(in,ilev)+acts(in+1,ilev))/2.
       cres(im,ilev)=(cacts(in,ilev)+cacts(in+1,ilev))/2.
       enddo
       do im=1,3
       res(im,ilev)=res(im+12,ilev)
       cres(im,ilev)=cres(im+12,ilev)
       enddo
       write(6,732)(res(im,ilev),im=1,12)
       write(6,732)(cres(im,ilev),im=1,12)
C      write(6,731)
732   format(24f5.1)
C     acloc for weeks 1, 2, 3, 4, 3&4
C wk1
      call loccor(save,savever,idim,jdim,17,1,acloco,ilev,nlev)
C     open file to write
      OPEN(UNIT=12,FILE=plotdatadir(1:NFILL(plotdatadir))
     * //'/'//expname(1:NFILL(expname))
     * //'.'//varname(1:NFILL(varname))
     * //'.wk1.raw.ac',FORM="unformatted")
C    write to file
      WRITE(12)(acloco)
C     close file
      CLOSE(12)

      call loccor(savesec,savever,idim,jdim,18,1,acloco,ilev,nlev)
C     open file to write
      OPEN(UNIT=12,FILE=plotdatadir(1:NFILL(plotdatadir))
     * //'/'//expname(1:NFILL(expname))
     * //'.'//varname(1:NFILL(varname))
     * //'.wk1.sec.ac',FORM="unformatted")
C    write to file
      WRITE(12)(acloco)
C     close file
      CLOSE(12)

C wk2
      call loccor(save,savever,idim,jdim,17,2,acloco,ilev,nlev)
C     open file to write
      OPEN(UNIT=12,FILE=plotdatadir(1:NFILL(plotdatadir))
     * //'/'//expname(1:NFILL(expname))
     * //'.'//varname(1:NFILL(varname))
     * //'.wk2.raw.ac',FORM="unformatted")
C    write to file
      WRITE(12)(acloco)
C     close file
      CLOSE(12)

      call loccor(savesec,savever,idim,jdim,18,2,acloco,ilev,nlev)
C     open file to write
      OPEN(UNIT=12,FILE=plotdatadir(1:NFILL(plotdatadir))
     * //'/'//expname(1:NFILL(expname))
     * //'.'//varname(1:NFILL(varname))
     * //'.wk2.sec.ac',FORM="unformatted")
C    write to file
      WRITE(12)(acloco)
C     close file
      CLOSE(12)

C wk3
      call loccor(save,savever,idim,jdim,17,3,acloco,ilev,nlev)
C     open file to write
      OPEN(UNIT=12,FILE=plotdatadir(1:NFILL(plotdatadir))
     * //'/'//expname(1:NFILL(expname))
     * //'.'//varname(1:NFILL(varname))
     * //'.wk3.raw.ac',FORM="unformatted")
C    write to file
      WRITE(12)(acloco)
C     close file
      CLOSE(12)

      call loccor(savesec,savever,idim,jdim,18,3,acloco,ilev)
C     open file to write
      OPEN(UNIT=12,FILE=plotdatadir(1:NFILL(plotdatadir))
     * //'/'//expname(1:NFILL(expname))
     * //'.'//varname(1:NFILL(varname))
     * //'.wk3.sec.ac',FORM="unformatted")
C    write to file
      WRITE(12)(acloco)
C     close file
      CLOSE(12)

C wk4
      call loccor(save,savever,idim,jdim,17,4,acloco,ilev)
C     open file to write
      OPEN(UNIT=12,FILE=plotdatadir(1:NFILL(plotdatadir))
     * //'/'//expname(1:NFILL(expname))
     * //'.'//varname(1:NFILL(varname))
     * //'.wk4.raw.ac',FORM="unformatted")
C    write to file
      WRITE(12)(acloco)
C     close file
      CLOSE(12)

      call loccor(savesec,savever,idim,jdim,18,4,acloco,ilev)
C     open file to write
      OPEN(UNIT=12,FILE=plotdatadir(1:NFILL(plotdatadir))
     * //'/'//expname(1:NFILL(expname))
     * //'.'//varname(1:NFILL(varname))
     * //'.wk4.sec.ac',FORM="unformatted")
C    write to file
      WRITE(12)(acloco)
C     close file
      CLOSE(12)

C wk4
      call loccor(save,savever,idim,jdim,17,34,acloco,ilev)
C     open file to write
      OPEN(UNIT=12,FILE=plotdatadir(1:NFILL(plotdatadir))
     * //'/'//expname(1:NFILL(expname))
     * //'.'//varname(1:NFILL(varname))
     * //'.wk34.raw.ac',FORM="unformatted")
C    write to file
      WRITE(12)(acloco)
C     close file
      CLOSE(12)

      call loccor(savesec,savever,idim,jdim,18,34,acloco,ilev)
C     open file to write
      OPEN(UNIT=12,FILE=plotdatadir(1:NFILL(plotdatadir))
     * //'/'//expname(1:NFILL(expname))
     * //'.'//varname(1:NFILL(varname))
     * //'.wk34.sec.ac',FORM="unformatted")
C    write to file
      WRITE(12)(acloco)
C     close file
      CLOSE(12)

c.. end level-loop
      enddo

 111   format(5i5,2x,6f10.2)
 112   format(4f7.1,f7.2,i6,2x,4f7.1,i4)
         return
         end
c
      function ac(anom,anom1,cosl,im,jm,fak,
     *ib,ie,lb,le,cov,sx,sy,r,ip,lp,gridm)
      dimension anom(im,jm),cosl(jm)
      dimension anom1(im,jm),gridm(im,jm)
      x=0.
      y=0.
      avx=0.
      avy=0.
      z=0.
      r=0.
      zz=0.
      do jlat=lb,le
      w=cosl(jlat)
      do i=ib,ie
c     if (gridm(i,jlat).gt.0.9)then!choice
      ax=anom(i,jlat)/fak
      ay=anom1(i,jlat)/fak
      avx=avx+ax*w
      avy=avy+ay*w
      x=x+(ax*ax)*w
      y=y+(ay*ay)*w
      z=z+(ay*ax)*w
      r=r+(ay-ax)*(ay-ax)*w
      zz=zz+w
c     endif
      enddo
      enddo
      sx=0.00000001
      sy=0.00000001
      if (x.gt.0.) sx=sqrt(x/zz)
      if (y.gt.0.) sy=sqrt(y/zz)
      if (r.gt.0.) r=sqrt(r/zz)
      ac=z/zz/sx/sy
      cov=z/zz
      avx=avx/zz
      avy=avy/zz
c     if((ip.eq.1).and.(lp.eq.5))
c    *write(6,101)avx,avy,sx,sy,ac*100.,lb,le,r,zz
101   format(1h ,'inside ac:',5f10.1,2i4,2f10.1)
      return
      end
c
      subroutine talley(rms,sx1,sy1,cv,lead,ilev,nlev,ihemi
     *,res1,res2,res3,res4,res5)
      dimension rms(144,6,140,nlev),sx1(144,6,140,nlev),
     *              sy1(144,6,140,nlev),cv(144,6,140,nlev)
       av1=0.
       av2=0.
       av3=0.
       av4=0.
       n=0
       do icase=1,144
       r=rms(icase,ihemi,lead,ilev)
       sx=sx1(icase,ihemi,lead,ilev)
       sy=sy1(icase,ihemi,lead,ilev)
       c=cv(icase,ihemi,lead,ilev)
       av1=av1+r*r
       av2=av2+sx*sx
       av3=av3+sy*sy
       av4=av4+c
       n=n+1
       enddo
       res1=sqrt(av1/float(n))
       res2=sqrt(av2/float(n))
       res3=sqrt(av3/float(n))
       res4=av4/float(n)
       res5=res4/(res2*res3)*100.
      return
      end
c
      subroutine loccor(save,savever,idim,jdim,idch,week,acloc,
     *ilev,nlev)
      real*4 save(idim,jdim,144,115,nlev)
      real*4 savever(idim,jdim,144,115,nlev)
      real*4 rms(idim,jdim),sx(idim,jdim),sy(idim,jdim),cov(idim,jdim)
      real*4 r(idim,jdim),x(idim,jdim),y(idim,jdim),acloc(idim,jdim)
      integer*4 week

      SELECT CASE (week)
        CASE (1)
c*      wk1:
        rms=0.
        sx=0.
        sy=0.
        cov=0.
        fak=27.*144.
        do icase=1,144
        do lead=1,27
        x(:,:)=save(:,:,icase,lead,ilev)
        y(:,:)=savever(:,:,icase,lead,ilev)
        r=x-y
        rms=rms+r*r/fak
        sx=sx+x*x/fak
        sy=sy+y*y/fak
        cov=cov+x*y/fak
        enddo
        enddo
        sx=sqrt(sx)
        sy=sqrt(sy)
        rms=sqrt(rms)
        acloc=100.*cov/(sx*sy)
c      write(idch)acloc
c      write(6,100)rms(1,40),sx(1,40),sy(1,40),acloc(1,40)    
c     call uslandave(gridm,idim,jdim,sx,sy,cov,rms,cosl,1,27)

        CASE (2)
c*      wk2:
        rms=0.
        sx=0.
        sy=0.
        cov=0.
        fak=28.*144.
        do icase=1,144
        do lead=28,55
        x(:,:)=save(:,:,icase,lead,ilev)
        y(:,:)=savever(:,:,icase,lead,ilev)
        r=x-y
        rms=rms+r*r/fak
        sx=sx+x*x/fak
        sy=sy+y*y/fak
        cov=cov+x*y/fak
        enddo
        enddo
        sx=sqrt(sx)
        sy=sqrt(sy)
        rms=sqrt(rms)
        acloc=100.*cov/(sx*sy)
c      write(idch)acloc
c      write(6,100)rms(1,40),sx(1,40),sy(1,40),acloc(1,40)
c     call uslandave(gridm,idim,jdim,sx,sy,cov,rms,cosl,28,55)
          
        CASE (3)
c*      wk3:
        rms=0.
        sx=0.
        sy=0.
        cov=0.
        fak=28.*144.
        do icase=1,144
        do lead=56,83
        x(:,:)=save(:,:,icase,lead,ilev)
        y(:,:)=savever(:,:,icase,lead,ilev)
        r=x-y
        rms=rms+r*r/fak
        sx=sx+x*x/fak
        sy=sy+y*y/fak
        cov=cov+x*y/fak
        enddo
        enddo
        sx=sqrt(sx)
        sy=sqrt(sy)
        rms=sqrt(rms)
        acloc=100.*cov/(sx*sy)
c      write(idch)acloc
c      write(6,100)rms(1,40),sx(1,40),sy(1,40),acloc(1,40)
c     call uslandave(gridm,idim,jdim,sx,sy,cov,rms,cosl,56,83)

        CASE (4)
c*      wk4:
        rms=0.
        sx=0.
        sy=0.
        cov=0.
        fak=28.*144.
        do icase=1,144
        do lead=84,111
        x(:,:)=save(:,:,icase,lead,ilev)
        y(:,:)=savever(:,:,icase,lead,ilev)
        r=x-y
        rms=rms+r*r/fak
        sx=sx+x*x/fak
        sy=sy+y*y/fak
        cov=cov+x*y/fak
        enddo
        enddo
        sx=sqrt(sx)
        sy=sqrt(sy)
        rms=sqrt(rms)
        acloc=100.*cov/(sx*sy)
c      write(idch)acloc
c      write(6,100)rms(1,40),sx(1,40),sy(1,40),acloc(1,40)
c     call uslandave(gridm,idim,jdim,sx,sy,cov,rms,cosl,84,111)
       
        CASE (34)
c*      wk3&4:
        rms=0.
        sx=0.
        sy=0.
        cov=0.
        fak=56.*144.
        do icase=1,144
        do lead=56,111
        x(:,:)=save(:,:,icase,lead,ilev)
        y(:,:)=savever(:,:,icase,lead,ilev)
        r=x-y
        rms=rms+r*r/fak
        sx=sx+x*x/fak
        sy=sy+y*y/fak
        cov=cov+x*y/fak
        enddo
        enddo
        sx=sqrt(sx)
        sy=sqrt(sy)
        rms=sqrt(rms)
        acloc=100.*cov/(sx*sy)
c      write(idch)acloc
c      write(6,100)rms(1,40),sx(1,40),sy(1,40),acloc(1,40)   
c     call uslandave(gridm,idim,jdim,sx,sy,cov,rms,cosl,56,111)
        CASE DEFAULT
          PRINT *,'Unknown week.'
      END SELECT

c100   format(1h ,'loc ac:',5f10.1)
      return
      end
c
      subroutine uslandave(gridm,idim,jdim,sx,sy,cov,rms,cosl,l1,l2)
      real*4 gridm(idim,jdim),sx(idim,jdim),sy(idim,jdim)
      real*4 rms(idim,jdim),cov(idim,jdim),cosl(jdim)
       x=0.
       y=0.
       c=0.
       w=0.
       r=0.
       do j=44,69
       do i=246,321
       if (gridm(i,j).gt.0.9)x=x+sx(i,j)*sx(i,j)*cosl(j)
       if (gridm(i,j).gt.0.9)y=y+sy(i,j)*sy(i,j)*cosl(j)
       if (gridm(i,j).gt.0.9)c=c+cov(i,j)*cosl(j)
       if (gridm(i,j).gt.0.9)r=rms(i,j)*cosl(j)
       if (gridm(i,j).gt.0.9)w=w+cosl(j)
       enddo
       enddo
       x=sqrt(x/w)
       y=sqrt(y/w)
       r=sqrt(r/w)
       acl=c/w/(x*y)*100.
       write(6,100)l1,l2,x,y,acl,w,r
100    format(1h ,'us-land-ave: ',2i5,5f7.2)
      return
      end
